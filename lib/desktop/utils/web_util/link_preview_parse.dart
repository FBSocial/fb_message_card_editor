// import 'package:flutter_link_preview/flutter_link_preview.dart';
// import 'package:html/dom.dart' hide Text;
// import 'package:html/parser.dart' as parser;
//
// class LinkPreviewParse {
//   static final RegExp _bodyReg =
//       RegExp(r"<body[^>]*>([\s\S]*?)<\/body>", caseSensitive: false);
//   static final RegExp _htmlReg = RegExp(
//       r"(<head[^>]*>([\s\S]*?)<\/head>)|(<script[^>]*>([\s\S]*?)<\/script>)|(<style[^>]*>([\s\S]*?)<\/style>)|(<[^>]+>)|(<link[^>]*>([\s\S]*?)<\/link>)|(<[^>]+>)",
//       caseSensitive: false);
//   static final RegExp _metaReg = RegExp(
//       r"<(meta|link)(.*?)\/?>|<title(.*?)</title>",
//       caseSensitive: false,
//       dotAll: true);
//   static final RegExp _titleReg =
//       RegExp("(title|icon|description|image)", caseSensitive: false);
//   static final RegExp _lineReg = RegExp(r"[\n\r]|&nbsp;|&gt;");
//   static final RegExp _spaceReg = RegExp(r"\s+");
//
//   static bool isNotEmpty(String str) {
//     return str != null && str.isNotEmpty;
//   }
//
//   static String _getHeadHtml(String html) {
//     html = html.replaceFirst(_bodyReg, "<body></body>");
//     final matchs = _metaReg.allMatches(html);
//     final StringBuffer head = StringBuffer("<html><head>");
//     if (matchs != null) {
//       matchs.forEach((element) {
//         final String str = element.group(0);
//         if (str.contains(_titleReg)) head.writeln(str);
//       });
//     }
//     head.writeln("</head></html>");
//     return head.toString();
//   }
//
//   static String _analyzeTitle(Document document) {
//     final title = _getMetaContent(document, "property", "og:title");
//     if (title != null) return title;
//     final list = document.head.getElementsByTagName("title");
//     if (list.isNotEmpty) {
//       final tagTitle = list.first.text;
//       if (tagTitle != null) return tagTitle.trim();
//     }
//     return "";
//   }
//
//   static String _getMetaContent(
//       Document document, String property, String propertyValue) {
//     final meta = document.head.getElementsByTagName("meta");
//     final ele = meta.firstWhere((e) => e.attributes[property] == propertyValue,
//         orElse: () => null);
//     if (ele != null) return ele.attributes["content"]?.trim();
//     return null;
//   }
//
//   static String _analyzeDescription(Document document, String html) {
//     final desc = _getMetaContent(document, "property", "og:description");
//     if (desc != null) return desc;
//
//     final description = _getMetaContent(document, "name", "description") ??
//         _getMetaContent(document, "name", "Description");
//
//     if (!isNotEmpty(description)) {
//       // final DateTime start = DateTime.now();
//       String body = html.replaceAll(_htmlReg, "");
//       body = body.trim().replaceAll(_lineReg, " ").replaceAll(_spaceReg, " ");
//       if (body.length > 300) {
//         body = body.substring(0, 300);
//       }
//       // logger.info("html cost ${DateTime.now().difference(start).inMilliseconds}");
//       return body;
//     }
//     return description;
//   }
//
//   static Future<InfoBase> getWebInfo(String html) async {
//     final headHtml = _getHeadHtml(html);
//     final document = parser.parse(headHtml);
//
//     String title = _analyzeTitle(document);
//     String description =
//         _analyzeDescription(document, html)?.replaceAll(r"\x0a", " ");
//     if (!isNotEmpty(title)) {
//       title = description;
//       description = null;
//     }
//
//     if (title.contains('404')) {
//       return null;
//     }
//
//     final info = WebInfo(
//       title: title,
//       icon: '', //_analyzeIcon(document, uri),
//       description: description,
//       mediaUrl: '', //_analyzeImage(document, uri),
//       redirectUrl: '', //response.request.url.toString(),
//     );
//     return info;
//   }
// }
