# Attendance_Automation

## Facial Recognition-based Attendance Automation System

The Facial Recognition-based Attendance Automation System is designed to streamline the process of taking attendance in classrooms or other educational settings using facial recognition technology. This system automates the traditional manual attendance process by capturing images of the classroom, detecting and recognizing faces, and marking students as present or absent based on comparison with a predefined dataset of enrolled students.

## Steps to run the project

1. Clone the git repository 
 `git clone https://github.com/SWEN-614-Team6/Attendance_Automation.git`

2. To run the terraform script navigate to 'terraforms' directory
- type `cd terraforms` 
- Run `terraform init` to initialize Terraform.
- Run `terraform plan` to see the execution plan.
- Run `terraform apply` to apply the changes and provision the infrastructure.
- To save deployed API URL Run `terraform output -json > ../homepage/src/output.txt`

3. To run the frontend url navigate to 'homepage' directory.
- w.r.t root directory type `cd homepage`
- Run `npm install` to install dependencies
- Run `npm start` to start the development server

4. Once the UI is loaded you can perform following functionalities :
- Add new student by mentioning firstname, lastname and uploading an image.
- Update Attendance by uploading class image and date of attendance.
 
5. To tear down or destroy infrastructure navigate to 'terraforms' directory and
- Run `terraform destroy` 