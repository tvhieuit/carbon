# Login API Documentation

This document describes the Login API implementation and the specific request/response format used in the application.

## Authentication Overview

The application uses standard POST-based authentication. Upon successful login, the server returns an access token and optionally a refresh token.

## Login Endpoint

- **URL**: `https://co2-api.118.69.67.72.nip.io/api/v1/auth/login`
- **Method**: `POST`
- **Content-Type**: `application/json`

### Request Headers

The following headers are automatically added by the `AuthInterceptor`:

| Header | Value | Description |
|--------|-------|-------------|
| `x-user-type` | `STAFF` | Identifies the user role |
| `Accept-Language` | `ja-JP` | Preferred language for responses |
| `x-provider` | (empty) | reserved for future provider identification |
| `Content-Type` | `application/json` | Request payload format |

### Request Body

The body must be a JSON object containing `username` and `password`.

```json
{
  "username": "tuannh479+20@gmail.com",
  "password": "your_password"
}
```

> [!NOTE]
> Although the UI might refer to this field as "Email", it is transmitted as `username` in the API request as per the current server specification.

### Successful Response (200 OK)

The server returns an `AuthToken` object containing user information and access/refresh tokens.

```json
{
    "id": "cd3c410b-b7fe-44d0-a35e-692938f3a80a",
    "email": "tuannh479+20@gmail.com",
    "user_type": "STAFF",
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "bbd9da4736a9473c",
    "expiration": "2026-03-13T09:30:04",
    "is_admin": false
}
```

### Error Responses

- **401 Unauthorized**: Invalid credentials.
- **403 Forbidden**: Account disabled or insufficient permissions.
- **404 Not Found**: Endpoint not found.
- **500 Internal Server Error**: Server-side issue.

## Implementation Details

- **Constants**: The base URL is defined in `Constants.apiUrl` within `apps/flutter_app/lib/utils/constants.dart`.
- **Repository**: `AuthRepositoryImpl` handles the API call and mapping in `packages/data/lib/src/repositories/auth_repository_impl.dart`.
- **Interceptor**: `AuthInterceptor` in `packages/data/lib/src/network/auth_interceptor.dart` ensures all required headers are present.

## Get Me API

- **URL**: `https://co2-api.118.69.67.72.nip.io/api/v1/auth/me`
- **Method**: `GET`
- **Authorization**: `Bearer <access_token>`

### Success Response (200 OK)

```json
{
    "id": "cd3c410b-b7fe-44d0-a35e-692938f3a80a",
    "email": "tuannh479+20@gmail.com",
    "is_active": true,
    "user_type": "STAFF",
    "role_id": "1daec5ae-b4ac-4c49-963c-516dc2aa513d",
    "permissions": ["staff__order__show", "staff__order__list", "staff__receipt__create"],
    "is_admin": false,
    "user_detail": {
        "id": "7a7fc389-5527-422d-b465-3431c12bcc93",
        "name": "西村ゆう",
        "phone": "0963729919",
        "is_inhourse": true,
        "tenant_store_id": "c404371a-b190-4bc1-a2cb-4e1578fd5f8f",
        "company_id": null
    }
}
```
