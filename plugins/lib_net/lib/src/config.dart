enum Env {
  dev,
  dev2, //开发环境2 原测试环境
  pre,
  pro,
  sandbox,
  newTest,
}

class HttpConfig {
  static bool useHttps = true;
  static late Env env = Env.newTest;

  static const _hosts = {
    Env.dev: "a1-dev.fanbook.mobi", // 开发环境
    Env.dev2: "a1-test.fanbook.mobi", // 开发环境2
    Env.newTest: "a1-newtest.fanbook.mobi", // 测试环境
    Env.sandbox: "a1-fat.fanbook.mobi", // 测试环境
    Env.pre: "a1-pre.fanbook.mobi", // 预发布环境
    Env.pro: "a1.fanbook.mobi", // 正式环境
  };

  static String get host => "${useHttps ? "https" : "http"}://${_hosts[env]}";

  ///默认链接审核域名
  static const _defaultLinkCheckHosts = {
    Env.pro: "https://risk.fanbook.mobi",
    Env.pre: "https://risk.fanbook.mobi",
    Env.sandbox: "https://risk-fat.fanbook.mobi",
    Env.newTest: "https://risk-newtest.fanbook.mobi",
    Env.dev: "https://risk-test.fanbook.mobi",
    Env.dev2: "https://risk-test.fanbook.mobi",
  };

  ///默认链接审核域名
  static String defaultLinkCheckHost = _defaultLinkCheckHosts[env] ?? "";
}
