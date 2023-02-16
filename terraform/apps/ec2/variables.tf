

variable "tags" {
  type = map(string)

  default = {
    TEAM = "dashdays-kibbles-and-bits"
    Role = "EC2 instance stuff"
  }
}