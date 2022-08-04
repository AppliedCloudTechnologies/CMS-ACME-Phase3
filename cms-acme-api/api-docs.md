# CMS-ACME API documentation
API documentation for CMS-ACME PatientAdmit service.

**License:** CMS-ACME license.

### /api/patient-admit

#### PUT
##### Description

To update PatientStatus record.

##### Responses

| Code | Description |
| ---- | ----------- |
| default | SUCCESS or ERROR |

### /info/status

#### GET
##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | OK |

### /api/patient-admit/{prov_nbr}/{patientId}

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

### /api/patient-admit/{patientId}

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

#### PatientStatusDTO

PatientStatus request object.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| status | string | _Enum:_ `"UNAFFECTED"`, `"INJURED"`, `"ILL_IN_FACILITY"`, `"ILL_NOT_IN_FACILITY"`, `"DECEASED"`, `"ISOLATED"` | No |
| notes | string |  | No |
| created_by | string |  | No |
| created_timestamp | string |  | No |
| modified_by | string |  | No |
| modified_timestamp | string |  | No |
| pat_id | string |  | Yes |
| prov_nbr | string |  | Yes |
| admit_date | string |  | No |
| disaster_type | string | _Enum:_ `"EARTHQUAKE"`, `"TORNADO"`, `"HURRICANE"`, `"PENDAMIC"`, `"OTHER"` | No |
| status_update_date | string |  | No |
| date_of_death | string |  | No |

#### CmsResponse

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| data | object |  | No |
| status | object |  | No |

#### CmsResponseStatus

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| description | string |  | No |
| code | string |  | No |

#### CmsResponsePatientStatusDTO

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| data | object | PatientStatus request object. | No |
| status | object |  | No |

#### CmsResponseListPatientStatusDTO

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| data | [ object ] |  | No |
| status | object |  | No |
