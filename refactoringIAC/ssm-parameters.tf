resource "aws_ssm_parameter" "sample_parameter" {
  name        = "Sample-Parameter-Name"
  description = "Description of the parameter"
  type        = "String"
  value       = "SampleParameterValueOrPassword"
  tier        = "Standard"

  tags = {
    Name = "ansong844-sample-ssm-parameter"
  }
}

# YOU CAN ADD MORE PARAMETERS USING THE ABOVE EXAMPLE.
