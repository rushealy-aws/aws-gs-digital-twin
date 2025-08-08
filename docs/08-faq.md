# Frequently Asked Questions (FAQ)

This document addresses common questions about AWS Ground Station Digital Twin.

## General Questions

### 1. What is AWS Ground Station Digital Twin?

AWS Ground Station Digital Twin provides an environment where you can test and integrate your satellite mission management and command and control software. The digital twin feature allows you to test scheduling, verification of configurations, and proper error handling without using production antenna capacity. It enables you to test AWS Ground Station APIs without using production capacity or requiring spectrum licensing.

### 2. How does Digital Twin differ from the standard AWS Ground Station service?

While AWS Ground Station provides actual satellite communication capabilities using physical ground station antennas, Digital Twin creates a simulated environment that mimics these capabilities. Digital Twin allows you to test configurations, dataflows, and procedures without using physical ground station infrastructure or actual satellite communications.

### 3. In which regions is AWS Ground Station Digital Twin available?

AWS Ground Station Digital Twin is available in regions where AWS Ground Station is supported. For the most current list of supported regions, refer to the [AWS Ground Station documentation](https://docs.aws.amazon.com/ground-station/latest/ug/what-is.html).

### 4. What are the prerequisites for using AWS Ground Station Digital Twin?

Prerequisites include:
- An active AWS account
- AWS Ground Station service enabled
- Appropriate IAM permissions
- Basic understanding of satellite communications
- AWS CLI or SDK configured (for programmatic access)

### 5. How much does AWS Ground Station Digital Twin cost?

AWS Ground Station Digital Twin pricing is based on simulation duration and features used. For the most current pricing information, refer to the [AWS Ground Station pricing page](https://aws.amazon.com/ground-station/pricing/). You can also use the [AWS Pricing Calculator](https://calculator.aws.amazon.com/) to estimate costs for your specific use case.

## Technical Questions

### 6. What satellite types and orbits are supported?

AWS Ground Station Digital Twin supports simulations for various satellite types and orbits, including:
- Low Earth Orbit (LEO)
- Medium Earth Orbit (MEO)

The service can simulate communications with satellites of various sizes and capabilities, from CubeSats to large commercial satellites.

### 7. What frequency bands are supported?

AWS Ground Station Digital Twin supports simulations across multiple frequency bands, including:
- S-band (2-4 GHz)
- X-band (8-12 GHz)
- Ka-band (26.5-40 GHz)

Support for specific frequencies within these bands may vary. Consult the service documentation for the most current information on supported frequencies.

### 8. Can I simulate multiple satellites simultaneously?

Yes, AWS Ground Station Digital Twin allows you to create simulations involving multiple satellites. This is particularly useful for testing constellation management, handover procedures, and multi-satellite operations.

### 9. What is the maximum duration for a simulation?

The default maximum duration for a single simulation is 24 hours. If you need longer simulations, you can request a quota increase through the AWS Service Quotas console.

### 10. How accurate are the simulations?

AWS Ground Station Digital Twin strives to provide high-fidelity simulations that closely match real-world conditions. The accuracy depends on several factors:
- Quality of provided ephemeris data
- Fidelity of satellite parameters
- Complexity of the communication scenario

For most testing purposes, the simulation accuracy is sufficient to validate configurations, procedures, and dataflows.

## Onboarding and Setup

### 11. How long does the onboarding process take?

The onboarding process typically takes 1-3 business days after submitting your request for access. This may vary based on your specific requirements and the current service demand.

### 12. Can I use my existing AWS Ground Station configurations with Digital Twin?

Yes, many of your existing AWS Ground Station configurations can be used with Digital Twin. However, some adjustments may be necessary to optimize for the simulated environment. The service will guide you through any required modifications during setup.

### 13. Do I need special hardware to use Digital Twin?

No, AWS Ground Station Digital Twin is a fully software-based simulation service that runs in the AWS cloud. You don't need any special hardware beyond what you would normally use to access AWS services.

### 14. How do I connect my existing ground systems to Digital Twin?

You can connect your existing ground systems to Digital Twin using the same dataflow endpoints you would use for the standard AWS Ground Station service. This includes:
- Amazon S3 buckets
- Amazon EC2 instances
- Custom dataflow endpoints

## Uplink Configuration

### 15. What uplink modulation schemes are supported?

AWS Ground Station Digital Twin supports various uplink modulation schemes, including:
- BPSK (Binary Phase Shift Keying)
- QPSK (Quadrature Phase Shift Keying)
- 8PSK (8-Phase Shift Keying)
- 16APSK (16-Amplitude Phase Shift Keying)
- FM (Frequency Modulation)

### 16. Can I test custom uplink waveforms?

Yes, AWS Ground Station Digital Twin allows you to test custom uplink waveforms. You can configure parameters such as:
- Modulation scheme
- Symbol rate
- FEC coding
- Spectral mask

### 17. How do I validate that my uplink commands were processed correctly?

Digital Twin provides several ways to validate uplink command processing:
1. Simulation logs that show command receipt and processing
2. Simulated satellite responses to commands
3. Metrics showing command acknowledgment rates
4. Downlink telemetry reflecting command execution

## Customer-Provided Ephemeris

### 18. What ephemeris formats are supported?

AWS Ground Station Digital Twin supports the following ephemeris formats:
- OEM (Orbit Ephemeris Message)
- TLE (Two-Line Element Set)
- CPE (Customer-Provided Ephemeris)

### 19. How often should I update ephemeris data?

For the most accurate simulations, we recommend updating ephemeris data:
- At least weekly for LEO satellites
- At least monthly for MEO satellites
- After any significant orbital maneuvers
- When simulation results show deviation from expected behavior

### 20. What happens if my ephemeris data doesn't cover the entire simulation period?

If your ephemeris data doesn't cover the entire simulation period, AWS Ground Station Digital Twin can:
1. Use orbit propagation to extend coverage (with potentially reduced accuracy)
2. Fall back to default orbital parameters
3. Limit the simulation to the covered time period (depending on your configuration)

### 21. Can I use real-time ephemeris updates during a simulation?

Currently, ephemeris data must be provided before starting a simulation. Real-time updates during an active simulation are not supported. For scenarios requiring updated ephemeris, we recommend creating a new simulation with the updated data.

## Troubleshooting

### 22. What should I do if my simulation fails to start?

If your simulation fails to start:
1. Check the error message in the AWS Ground Station console
2. Verify that all required resources (satellite, mission profile, etc.) exist
3. Ensure your IAM role has the necessary permissions
4. Validate that your ephemeris data is correctly formatted
5. Check that your start and end times are valid

### 23. How can I diagnose dataflow issues?

To diagnose dataflow issues:
1. Verify dataflow endpoint configuration
2. Check network connectivity between AWS Ground Station and your endpoints
3. Ensure proper IAM permissions for S3 buckets or EC2 instances
4. Review CloudWatch logs for error messages
5. Test with simplified dataflow configurations

### 24. Where can I find logs for my simulations?

Simulation logs are available in:
1. CloudWatch Logs under the `/aws/groundstation/digital-twin` log group
2. The AWS Ground Station console under the simulation details page
3. Through the AWS CLI using the `aws logs` commands

### 25. What are the most common error codes and their solutions?

| Error Code | Common Cause | Solution |
|------------|--------------|----------|
| `AccessDeniedException` | Insufficient IAM permissions | Review and update IAM policies |
| `InvalidParameterException` | Incorrect parameter values | Check parameter values against documentation |
| `ResourceNotFoundException` | Resource doesn't exist or wrong region | Verify resource IDs and region |
| `ValidationException` | Input validation failure | Check input format and constraints |
| `LimitExceededException` | Service quota exceeded | Request quota increase or optimize usage |

## Best Practices

### 26. How can I optimize costs when using Digital Twin?

To optimize costs:
1. Schedule simulations only for the duration needed
2. Delete unused resources promptly
3. Use shorter simulations for initial testing
4. Schedule non-urgent simulations during off-peak hours
5. Monitor usage with AWS Cost Explorer

### 27. What's the recommended approach for testing a new satellite configuration?

We recommend:
1. Start with a short (1-2 hour) basic simulation
2. Verify basic connectivity and dataflow
3. Gradually increase complexity with additional features
4. Test edge cases and failure scenarios
5. Run a full-duration simulation only after validating components

### 28. Should I use separate AWS accounts for testing and production?

Yes, we recommend using separate AWS accounts for:
- Development and testing
- Production simulations
- Actual AWS Ground Station operations

This separation helps prevent accidental changes to production configurations and provides clearer cost allocation.

### 29. How can I automate Digital Twin testing?

You can automate testing by:
1. Using AWS SDK or CLI in scripts
2. Integrating with CI/CD pipelines
3. Using AWS Step Functions for workflow orchestration
4. Implementing CloudWatch Events for event-driven automation
5. Creating custom dashboards for monitoring

## Additional Resources

### 30. Where can I find more information about AWS Ground Station Digital Twin?

Additional resources include:
- [AWS Ground Station Documentation](https://docs.aws.amazon.com/ground-station/)
- [AWS Ground Station Blog Posts](https://aws.amazon.com/blogs/aws/category/satellite/)
- [AWS re:Invent Sessions](https://www.youtube.com/results?search_query=aws+reinvent+ground+station)
- [AWS Workshops](https://workshops.aws/)

### 31. How do I request feature enhancements or report bugs?

You can request features or report bugs through:
1. Your AWS account representative
2. AWS Support (if you have a support plan)
3. The AWS Ground Station forum
4. GitHub issues for AWS SDK and CLI

### 32. Is there a community of AWS Ground Station Digital Twin users?

Yes, you can connect with other users through:
- [AWS Ground Station forum](https://forums.aws.amazon.com/)
- AWS re:Invent and regional events
- Industry conferences and meetups
- LinkedIn groups focused on satellite communications

### 33. How can I get technical support for AWS Ground Station Digital Twin?

Technical support is available through:
1. AWS Support plans (Basic, Developer, Business, Enterprise)
2. AWS documentation and knowledge base
3. AWS forums
4. Your AWS account team (for enterprise customers)

## Next Steps

After reviewing these FAQs, explore the [Resources](09-resources.md) section for additional documentation, sample code, and reference materials.
