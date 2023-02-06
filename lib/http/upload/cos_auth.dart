class CosAuth {
  final String? token;
  final String? host;
  final String? authorization;
  final String? uploadPath;
  final String? uploadPathService;
  final String? cdnUrl;
  final String? auditUrl;
  final String? auditToken;
  final String? auditHost;
  final String? auditAuthorization;
  final String? auditType;

  final String secretId;
  final String secretKey; //加密後的secretKey
  final String auditsecretId;
  final String auditSecretKey; //加密後的secretKey
  final int startTs;
  final int expiredTs;
  final String bucket;
  final String auditBucket;
  String? decodeSecretKey; //解密secretKey
  String? decodeAuditSecretKey;

  CosAuth(
      this.token,
      this.host,
      this.authorization,
      this.uploadPath,
      this.uploadPathService,
      this.cdnUrl,
      this.auditUrl,
      this.auditToken,
      this.auditHost,
      this.auditAuthorization,
      this.auditType,
      this.secretId,
      this.secretKey,
      this.auditsecretId,
      this.auditSecretKey,
      this.startTs,
      this.expiredTs,
      this.bucket,
      this.auditBucket);

  factory CosAuth.fromJson(Map<String, dynamic> srcJson) =>
      _$CosAuthFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CosAuthToJson(this);

  bool checkAuthIsAvailable() {
    return token != null &&
        token!.isNotEmpty &&
        host != null &&
        host!.isNotEmpty &&
        authorization != null &&
        authorization!.isNotEmpty &&
        uploadPath != null &&
        uploadPath!.isNotEmpty &&
        uploadPathService != null &&
        uploadPathService!.isNotEmpty &&
        cdnUrl != null &&
        cdnUrl!.isNotEmpty &&
        auditUrl != null &&
        auditUrl!.isNotEmpty &&
        auditToken != null &&
        auditToken!.isNotEmpty &&
        auditHost != null &&
        auditHost!.isNotEmpty &&
        auditAuthorization != null &&
        auditAuthorization!.isNotEmpty &&
        auditType != null &&
        auditType!.isNotEmpty;
  }
}

CosAuth _$CosAuthFromJson(Map<String, dynamic> json) {
  return CosAuth(
    json['token'] as String?,
    json['host'] as String?,
    json['authorization'] as String?,
    json['upload_path'] as String?,
    json['upload_path_service'] as String?,
    json['url'] as String?,
    json['audit_url'] as String?,
    json['audit_token'] as String?,
    json['audit_host'] as String?,
    json['audit_authorization'] as String?,
    json['audit_type'] as String?,
    json['secretId'] ?? '',
    json['secretKey'] ?? '',
    json['audit_secretId'] ?? '',
    json['audit_secretKey'] ?? '',
    json['start_time'] ?? 0,
    json['expired_time'] ?? 0,
    json['bucket'] ?? '',
    json['audit_bucket'] ?? '',
  );
}

Map<String, dynamic> _$CosAuthToJson(CosAuth instance) => <String, dynamic>{
      'token': instance.token,
      'host': instance.host,
      'authorization': instance.authorization,
      'upload_path': instance.uploadPath,
      'upload_path_service': instance.uploadPathService,
      'url': instance.cdnUrl,
      'audit_url': instance.auditUrl,
      'audit_token': instance.auditToken,
      'audit_host': instance.auditHost,
      'audit_authorization': instance.auditAuthorization,
      'audit_type': instance.auditType,
      'secretId': instance.secretId,
      'secretKey': instance.secretKey,
      'audit_secretId': instance.auditsecretId,
      'audit_secretKey': instance.auditSecretKey,
      'start_time': instance.startTs,
      'expired_time': instance.expiredTs,
      'bucket': instance.bucket,
      'audit_bucket': instance.auditBucket
    };
