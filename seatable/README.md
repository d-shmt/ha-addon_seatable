# Home Assistant Add-on: Seatable

## About

This add-on provides Seatable, a spreadsheet-like database solution, for your Home Assistant instance.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
2. Add this repository URL: https://github.com/d-shmt/ha-addon_seatable
3. Find the "Seatable" add-on and click it.
4. Click on the "INSTALL" button.

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml
admin_email: admin@example.com
admin_password: verysecurepassword
db_password: anothersecurepassword
secret_key: randomstring