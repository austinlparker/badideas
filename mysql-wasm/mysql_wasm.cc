#include <mysql.h>

#include <cerrno>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <string>
#include <sys/stat.h>

#ifdef __EMSCRIPTEN__
#include <emscripten/emscripten.h>
#define WASM_EXPORT EMSCRIPTEN_KEEPALIVE
#else
#define WASM_EXPORT
#endif

namespace {

MYSQL *connection = nullptr;
std::string response;

void append_json_string(std::string &out, const char *value, std::size_t length)
{
  static const char hex[] = "0123456789abcdef";
  out.push_back('"');
  for (std::size_t i = 0; i < length; ++i)
  {
    const unsigned char ch = static_cast<unsigned char>(value[i]);
    switch (ch)
    {
      case '"': out += "\\\""; break;
      case '\\': out += "\\\\"; break;
      case '\b': out += "\\b"; break;
      case '\f': out += "\\f"; break;
      case '\n': out += "\\n"; break;
      case '\r': out += "\\r"; break;
      case '\t': out += "\\t"; break;
      default:
        if (ch < 0x20)
        {
          out += "\\u00";
          out.push_back(hex[ch >> 4]);
          out.push_back(hex[ch & 0x0f]);
        }
        else
        {
          out.push_back(static_cast<char>(ch));
        }
    }
  }
  out.push_back('"');
}

const char *error_json(const char *message)
{
  response = "{\"error\":";
  append_json_string(response, message, std::strlen(message));
  response.push_back('}');
  return response.c_str();
}

void make_directory(const char *path)
{
  if (mkdir(path, 0755) != 0 && errno != EEXIST)
  {
    response = "cannot create ";
    response += path;
    response += ": ";
    response += std::strerror(errno);
  }
}

std::string read_file(const char *path)
{
  std::string contents;
  FILE *file = std::fopen(path, "rb");
  if (file == nullptr)
    return contents;

  char buffer[1024];
  std::size_t count;
  while ((count = std::fread(buffer, 1, sizeof(buffer), file)) != 0)
    contents.append(buffer, count);
  std::fclose(file);
  return contents;
}

}  // namespace

extern "C" {

WASM_EXPORT const char *mysql_wasm_init()
{
  if (connection != nullptr)
    return "";

  response.clear();
  make_directory("/mysql");
  make_directory("/mysql/data");
  make_directory("/mysql/data/mysql");
  make_directory("/mysql/tmp");
  if (!response.empty())
  {
    const std::string directory_error = response;
    return error_json(directory_error.c_str());
  }

  // MySQL's option parser mutates argv, so these must be writable arrays.
  static char arg0[] = "mysql-wasm";
  static char basedir[] = "--basedir=/mysql";
  static char datadir[] = "--datadir=/mysql/data";
  static char language[] = "--lc-messages-dir=/mysql/share";
  static char charsets[] = "--character-sets-dir=/mysql/share/charsets";
  static char tmpdir[] = "--tmpdir=/mysql/tmp";
  static char engine[] = "--default-storage-engine=MyISAM";
  static char log_error[] = "--log-error=/mysql/error.log";
  static char innodb[] = "--skip-innodb";
  static char *server_options[] = {
    arg0,
    basedir,
    datadir,
    language,
    charsets,
    tmpdir,
    engine,
    log_error,
    innodb,
    nullptr
  };
  static char group0[] = "embedded";
  static char group1[] = "server";
  static char *server_groups[] = {group0, group1, nullptr};

  const int option_count =
    static_cast<int>(sizeof(server_options) / sizeof(server_options[0])) - 1;
  if (mysql_library_init(option_count, server_options, server_groups) != 0)
  {
    std::string message = "mysql_library_init failed";
    const std::string log = read_file("/mysql/error.log");
    if (!log.empty())
    {
      message += ": ";
      message += log;
    }
    return error_json(message.c_str());
  }

  connection = mysql_init(nullptr);
  if (connection == nullptr)
    return error_json("mysql_init failed");

  mysql_options(connection, MYSQL_OPT_USE_EMBEDDED_CONNECTION, nullptr);
  if (mysql_real_connect(connection, nullptr, "root", "", nullptr, 0, nullptr, 0) == nullptr)
  {
    const std::string connection_error = mysql_error(connection);
    mysql_close(connection);
    connection = nullptr;
    return error_json(connection_error.c_str());
  }

  return "";
}

WASM_EXPORT const char *mysql_wasm_query(const char *sql)
{
  if (connection == nullptr)
    return error_json("MySQL is not initialized");
  if (sql == nullptr)
    return error_json("mysqlQuery requires a SQL string");

  if (mysql_real_query(connection, sql, static_cast<unsigned long>(std::strlen(sql))) != 0)
    return error_json(mysql_error(connection));

  MYSQL_RES *result = mysql_store_result(connection);
  if (result == nullptr)
  {
    if (mysql_field_count(connection) != 0)
      return error_json(mysql_error(connection));

    response = "{\"affectedRows\":";
    response += std::to_string(mysql_affected_rows(connection));
    response += ",\"insertId\":";
    response += std::to_string(mysql_insert_id(connection));
    response.push_back('}');
    return response.c_str();
  }

  const unsigned int field_count = mysql_num_fields(result);
  MYSQL_FIELD *fields = mysql_fetch_fields(result);
  response = "{\"columns\":[";
  for (unsigned int i = 0; i < field_count; ++i)
  {
    if (i != 0)
      response.push_back(',');
    append_json_string(response, fields[i].name, fields[i].name_length);
  }
  response += "],\"rows\":[";

  bool first_row = true;
  MYSQL_ROW row;
  while ((row = mysql_fetch_row(result)) != nullptr)
  {
    unsigned long *lengths = mysql_fetch_lengths(result);
    if (!first_row)
      response.push_back(',');
    first_row = false;
    response.push_back('[');
    for (unsigned int i = 0; i < field_count; ++i)
    {
      if (i != 0)
        response.push_back(',');
      if (row[i] == nullptr)
        response += "null";
      else
        append_json_string(response, row[i], lengths[i]);
    }
    response.push_back(']');
  }

  response += "]}";
  mysql_free_result(result);
  return response.c_str();
}

WASM_EXPORT void mysql_wasm_shutdown()
{
  if (connection != nullptr)
  {
    mysql_close(connection);
    connection = nullptr;
  }
  mysql_library_end();
}

}  // extern "C"
