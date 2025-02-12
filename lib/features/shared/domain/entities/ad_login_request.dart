class AdLoginRequest {
    String? user;
    String? pass;
    String? lang;
    int? clientId;
    int? roleId;
    int? orgId;
    int? warehouseId;
    int? stage;

    AdLoginRequest({
        this.user,
        this.pass,
        this.lang,
        this.clientId,
        this.roleId,
        this.orgId,
        this.warehouseId,
        this.stage,
    });

    // factory AdLoginRequest.jsonToEntity(Map<String, dynamic> json) => AdLoginRequest(
    //     user: json["user"],
    //     pass: json["pass"],
    //     lang: json["lang"],
    //     clientId: json["ClientID"],
    //     roleId: json["RoleID"],
    //     orgId: json["OrgID"],
    //     warehouseId: json["WarehouseID"],
    //     stage: json["stage"],
    // );

    AdLoginRequest copyWith({
        String? user,
        String? pass,
        String? lang,
        int? clientId,
        int? roleId,
        int? orgId,
        int? warehouseId,
        int? stage,
    }) => 
        AdLoginRequest(
            user: user ?? this.user,
            pass: pass ?? this.pass,
            lang: lang ?? this.lang,
            clientId: clientId ?? this.clientId,
            roleId: roleId ?? this.roleId,
            orgId: orgId ?? this.orgId,
            warehouseId: warehouseId ?? this.warehouseId,
            stage: stage ?? this.stage,
        );
}