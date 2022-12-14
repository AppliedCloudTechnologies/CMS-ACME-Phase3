# CMS-ACME API documentation
API documentation for CMS-ACME PatientStatus service.

**License:** CMS-ACME license.

### /api/patient-status

#### PUT
##### Description

To update PatientStatus record.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| PatientStatusRequestDTO | body | PatientStatus update object. | Yes | [PatientStatusRequestDTO](#patientstatusrequestdto) |

##### Responses

| Code | Description |
| ---- | ----------- |
| default | SUCCESS or ERROR |

### /info/status

#### GET
##### Description

To the status of service.

##### Responses

| Code | Description |
| ---- | ----------- |
| default | status: up |

### /api/patient-status/{prov_nbr}/{patientId}

#### GET
##### Description

To fetch PatientStatus record based on patientId and providerId.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| prov_nbr | path | Provider's id | Yes | string |
| patientId | path | Patient's id | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| default | Returns PatientStatus matching provNbr and patientId |

### /api/patient-status/{patientId}

#### GET
##### Description

To fetch List of PatientStatus for a particular patient.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| patientId | path | Patient's id | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| default | Returns List of all PatientStatus matching given patientId. |

### Models

#### PatientStatusRequestDTO

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| status | string | _Enum:_ `"UNAFFECTED"`, `"INJURED"`, `"ILL_IN_FACILITY"`, `"ILL_NOT_IN_FACILITY"`, `"DECEASED"`, `"ISOLATED"` | Yes |
| notes | string |  | No |
| pat_id | string |  | Yes |
| disaster_type | string | _Enum:_ `"EARTHQUAKE"`, `"TORNADO"`, `"HURRICANE"`, `"PENDAMIC"`, `"OTHER"` | Yes |
| date_of_death | string |  | No |

#### CmsResponseObject

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| data | object |  | No |
| status | object |  | No |

#### CmsResponseStatus

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| description | string |  | No |
| code | string |  | No |

#### CmsResponsePatientStatusResponseDTO

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| data | object |  | No |
| status | object |  | No |

#### PatientStatusResponseDTO

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| status | string | _Enum:_ `"UNAFFECTED"`, `"INJURED"`, `"ILL_IN_FACILITY"`, `"ILL_NOT_IN_FACILITY"`, `"DECEASED"`, `"ISOLATED"` | No |
| notes | string |  | No |
| created_by | string |  | No |
| created_timestamp | string |  | No |
| modified_by | string |  | No |
| modified_timestamp | string |  | No |
| pat_id | string |  | Yes |
| prov_nbr | string |  | No |
| disaster_type | string | _Enum:_ `"EARTHQUAKE"`, `"TORNADO"`, `"HURRICANE"`, `"PENDAMIC"`, `"OTHER"` | No |
| status_update_date | string |  | No |
| date_of_death | string |  | No |

#### CmsResponseListPatientStatusResponseDTO

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| data | [ object ] |  | No |
| status | object |  | No |
