# AWS Ground Station Digital Twin - Getting Started Guide

This repository contains comprehensive documentation for getting started with AWS Ground Station Digital Twin, including onboarding steps, usage guides for uplink and customer-provided ephemeris, and detailed troubleshooting procedures.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](docs/01-prerequisites.md)
- [Onboarding](docs/02-onboarding.md)
  - [Account Setup](docs/02-onboarding.md#account-setup)
  - [IAM Permissions](docs/02-onboarding.md#iam-permissions)
  - [Network Configuration](docs/02-onboarding.md#network-configuration)
- [Using AWS Ground Station Digital Twin](docs/03-using-digital-twin.md)
  - [Console Overview](docs/03-using-digital-twin.md#console-overview)
  - [API Reference](docs/03-using-digital-twin.md#api-reference)
  - [CLI Commands](docs/03-using-digital-twin.md#cli-commands)
- [Uplink Configuration](docs/04-uplink-configuration.md)
  - [Setting Up Uplink](docs/04-uplink-configuration.md#setting-up-uplink)
  - [Uplink Waveforms](docs/04-uplink-configuration.md#uplink-waveforms)
  - [Uplink Scheduling](docs/04-uplink-configuration.md#uplink-scheduling)
- [Customer-Provided Ephemeris](docs/05-customer-provided-ephemeris.md)
  - [Ephemeris Format](docs/05-customer-provided-ephemeris.md#ephemeris-format)
  - [Uploading Ephemeris Data](docs/05-customer-provided-ephemeris.md#uploading-ephemeris-data)
  - [Ephemeris Validation](docs/05-customer-provided-ephemeris.md#ephemeris-validation)
- [Troubleshooting](docs/06-troubleshooting.md)
  - [Common Issues](docs/06-troubleshooting.md#common-issues)
  - [Error Codes](docs/06-troubleshooting.md#error-codes)
  - [Support Channels](docs/06-troubleshooting.md#support-channels)
- [Best Practices](docs/07-best-practices.md)
- [FAQ](docs/08-faq.md)
- [Resources](docs/09-resources.md)

## Introduction

AWS Ground Station Digital Twin provides an environment where you can test and integrate your satellite mission management and command and control software. The digital twin feature allows you to test scheduling, verification of configurations, and proper error handling without using production antenna capacity. Testing your AWS Ground Station integration with the digital twin feature enables you to have increased confidence in your system's ability to manage your satellite operations smoothly. It also allows you to test AWS Ground Station APIs without using production capacity or requiring spectrum licensing.

For more detailed information, refer to the specific documentation sections in this repository.
