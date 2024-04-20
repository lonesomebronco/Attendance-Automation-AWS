import { Button, Modal, ModalHeader, ModalBody, ModalFooter,Form, FormGroup, Label, Input } from 'reactstrap';
import React from 'react';
import './App.css';
import { useState, useEffect } from 'react';
import logo from './image/logo.png';
import registrationImg from './image/registration.png';
import addAttendanceImg from './image/addAttendance.png';
import myfile from './output.txt';


// import { Auth , Amplify } from 'aws-amplify';
import { Amplify } from 'aws-amplify';
import { Authenticator, withAuthenticator } from '@aws-amplify/ui-react';

import '@aws-amplify/ui-react/styles.css';
import awsExports from './aws-exports';

Amplify.configure(awsExports);

// import BASE_URL from './config'; 
const apiUrl = process.env.REACT_APP_API_ENDPOINT;
const uuid = require('uuid');

function App() {

  console.log("API-", apiUrl);

  const [image, setImage] = useState('');
  const [classImage, setclassImage] = useState('');

  const [registerModal, setRegisterModal] = useState(false);
  const [updateModal, setUpdateModal] = useState(false);

  const [text_message,settext_message] = useState('');
  const [new_student_msg, setnew_student_msg] = useState('');

  const [studentlist, setstudentlist] = useState([]);
  
  const [absent_studentlist, set_absent_studentlist] = useState([]);

  const [absent_student_message, set_absent_student_message] = useState('');

  const [selectedDate, setSelectedDate] = useState('');
  const [BASE_URL, setBASE_URL] = useState(null);

  useEffect(() => {
    const fetchJsonData = async () => {
      try {
        const response = await fetch(myfile);
        if (!response.ok) {
          throw new Error('Failed to fetch JSON');
        }
        const data = await response.json();
        setBASE_URL(data.API_invoke_url.value);
        console.log(data.API_invoke_url.value);
      } catch (error) {
        console.error('Error fetching JSON:', error);
      }
    };

    fetchJsonData();
  }, []);





  const toggleUpdateModal = () => {
    setUpdateModal(!updateModal);
    settext_message('');
    setSelectedDate('');
    setstudentlist([]);

    set_absent_student_message('');
    set_absent_studentlist([]);

  }

  const toggleRegisterModal = () => {
    setRegisterModal(!registerModal);
    setnew_student_msg('');

  }


  const handleSubmit = (event) => {
    event.preventDefault();

  const firstName = event.target.first_name.value;
  const lastName = event.target.last_name.value;
  const fileExtension = image.name.split('.').pop();
  event.target.first_name.value = '';
  event.target.last_name.value = '';

 const visitorImageName = `${firstName}_${lastName}.${fileExtension}`;

    // fetch(`https://chcxp4zpi8.execute-api.us-east-1.amazonaws.com/dev5/register-new-student/${visitorImageName}`, {
    fetch(`${apiUrl}/new-student-registration-tf/${visitorImageName}`, { 
    method : 'PUT',
    headers :  {
     // 'Content-Type' : 'image/jpeg'
     'Content-Type': `image/${fileExtension}`
    },
    body : image
   }).catch(error => {
    
    console.error(error);
   })
   setnew_student_msg('New Student added successfully');
  }

  const handleUpdateSubmit = (event) => {
    event.preventDefault();
   const visitorImageName = uuid.v4();
    
   const newfileExtension = classImage.name.split('.').pop();
  //  fetch(`https://chcxp4zpi8.execute-api.us-east-1.amazonaws.com/dev5/class/class-photos-bucket/${visitorImageName}`, {
    fetch(`${apiUrl}/class/class-images-tf/${visitorImageName}`, { // Construct the API endpoint using the base URL
   method : 'PUT',
    headers :  {
      'Content-Type': `image/${newfileExtension}`,
      // 'Origin': 'http://localhost:3000'
    },
    body : classImage
   }).then(async () => {
    const response = await authenticate(visitorImageName, newfileExtension);
    console.log(response);
    if(response.status === 'Success')
    {
     console.log(response.mylist);
     setstudentlist(response.mylist);
     settext_message(response.message);
     set_absent_student_message(response.absent_message);
     set_absent_studentlist(response.absent_students);
      // settext_message(`${response['message']} :`);
    }
    else 
    {
      settext_message('Attendance Updation Failed');
    }
   }).catch(error => {
    console.error(error);
   })

  }
  
  async function authenticate(visitorImageName, newfileExtension)
  {
  //   const requestUrl = 'https://chcxp4zpi8.execute-api.us-east-1.amazonaws.com/dev5/studentidentify?'+ new URLSearchParams({
  //    objectKey : `${visitorImageName}`,
  //    date_of_attendance : `${selectedDate}`
  //  })
  const requestUrl = `${apiUrl}/studentidentify?${new URLSearchParams({ // Construct the API endpoint using the base URL
    objectKey: `${visitorImageName}`,
    date_of_attendance: `${selectedDate}`
  })}`;
   return await fetch(requestUrl, {
     method : 'GET',
     headers : {
       'Accept' :'application/json',
       'Content-Type' : 'application/json'
      //  'Origin': 'http://localhost:3000'
     }
   }).then(response => response.json())
   .then ((data) => {
     return data;
   }).catch(error => console.error(error));
  
  }

  return (
   <div>
   <Authenticator>
   {({ signOut }) => (
    <main>
    <div className='header'>
      <img src = {logo} alt='Logo'/>
      <h1>Attendance Automation</h1>
      {/* <button onClick={() => Auth.signOut()}>Sign Out</button> */}

      <Button onClick={signOut}>Sign Out</Button>
    </div>
      
    <h2>Welcome, Admin!!</h2>
    <div className='buttons'>
      <div className='b'>
          <Button className="circular-button" onClick={toggleRegisterModal}> 
            <img src= {registrationImg} alt='registration'/>
          </Button>
          <div>Registration</div>
      </div>
      <div className='b'>
          <Button className="circular-button" onClick={toggleUpdateModal}>
            <img src= {addAttendanceImg} alt='addAttandance'/>
          </Button>
          <div>Mark Attendance</div>
      </div>
    </div>
    
      

      <Modal isOpen={updateModal} toggle={toggleUpdateModal}>
        <ModalHeader color='black' toggle={toggleUpdateModal}>Upload Attendance</ModalHeader>
        
        <ModalBody>
          <Form onSubmit={handleUpdateSubmit}>
            <FormGroup>
              <Label for="upload_photo">Upload Class Photo</Label>
              <Input type='file' name='upload_photo' onChange={e => setclassImage(e.target.files[0])} />
            </FormGroup>

            <FormGroup>
              <Label for="date">Select Date</Label>
              <Input type='date' name='date' value={selectedDate} onChange={e => setSelectedDate(e.target.value)} />
            </FormGroup>

            
            <h3>{text_message}</h3>
            {studentlist.map((mylist, index) => (
                <p>{mylist.firstName} {mylist.lastName}</p>
            ))}

            <h4>{absent_student_message}</h4>
            {absent_studentlist.map((mylist, index) => (
                <p>{mylist.firstName} {mylist.lastName}</p>
            ))}


            <Button color='primary' type='submit'>Submit</Button>
          </Form>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggleUpdateModal}>Cancel</Button>
        </ModalFooter>

      </Modal>

      <Modal isOpen={registerModal} toggle={toggleRegisterModal}>
        <ModalHeader toggle={toggleRegisterModal}>Add Student's Details</ModalHeader>
        <ModalBody>

          <Form onSubmit={handleSubmit}>

            <FormGroup>
              <Label for="first_name">First Name</Label>
              <Input type="text" name="first_name" id="first_name" placeholder="Enter first name" />
            </FormGroup>

            <FormGroup>
              <Label for="last_name">Last Name</Label>
              <Input type="text" name="last_name" id="last_name" placeholder="Enter last name" />
            </FormGroup>

            <FormGroup>
              <Input type='file' name='image' onChange={e => setImage(e.target.files[0])} />
            </FormGroup>

            <FormGroup>
              <h3>{new_student_msg}</h3>
            </FormGroup>

            <Button color="primary" type="submit">Submit</Button>
          </Form>

        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggleRegisterModal}>Cancel</Button>
        </ModalFooter>
      </Modal>
      </main>
       )}
      </Authenticator>
   </div>
  );
}

// export default App;
export default withAuthenticator(App);
