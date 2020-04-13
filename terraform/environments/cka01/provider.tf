provider "google" {

  credentials = file("../../../credentials/credentials.json")
  project     = "CHANGE_ME"
  region      = "CHANGE_ME"
  zone        = "CHANGE_ME"

}
