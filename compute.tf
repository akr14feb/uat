variable "compute_shape" {
  type    = string
  default = "VM.Standard.E2.1.Micro"
}

variable "compute_cpus" {
  type    = string
  default = "1"
}

variable "compute_memory_in_gbs" {
  type    = string
  default = "1"
}

# Get the images
# oci compute image list --compartment-id 
ocid1.compartment.oc1..aaaaaaaafd7xmyq33gii4astc72c6uk3qd4ymp6o22x7wee3zmfj5xc6a4la

variable "compute_image" {
  type    = string
  default = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaapn7ecriowkabr6akpkba5reocgqneqp3pdtrbe6asjatibkhtp6a"
}


variable "compute_ssh_authorized_keys" { 
     type = string 
     default = "oci_pub_api_key.pub"
}


resource "oci_core_instance" "tf_compute" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ad_list.availability_domains[0].name
  compartment_id      = local.zen-comp-non-prod-id
  shape               = var.compute_shape

source_details {
source_type = "image"
source_id = var.compute_image
}

  # Optional
  display_name        = "oraclebsapps1"

  shape_config {
    ocpus         = var.compute_cpus
    memory_in_gbs = var.compute_memory_in_gbs
  }

  create_vnic_details {
    subnet_id         = local.testapps_subnet_ocid
    assign_public_ip  = true
  }


 metadata = {
    ssh_authorized_keys = file(var.compute_ssh_authorized_keys)
  }


  preserve_boot_volume = false
}


# Outputs
output "compute_id" {
  value = oci_core_instance.tf_compute.id
}

output "db_state" {
  value = oci_core_instance.tf_compute.state
}

output "compute_public_ip" {
  value = oci_core_instance.tf_compute.public_ip
}