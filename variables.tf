variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "key_name" {
    type = string   # default deger yazmadigimiz icin; burasi artik required oldu. bunu kullacak user lar bu degiskeni tanimlamak zorunda
  
}

variable "num_of_instance" {
    type = number
    default =  1
}

variable "tag" {
    type = string
    default = "Docker-Instance"
}

variable "server_name" {
    type = string
    default = "docker-instance"
}


variable "docker-instance-ports" {
    type = list(number)
    default = [22, 80, 8080]
    description = "desdocker-instance-sec-gr-inbound-rulescription"
}







