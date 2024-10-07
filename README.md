# 📹 MediaPicker

As we know Apples UIPickerViewController provides us the functionality to select single image at a time, since our use case is to select multiple images we thought of building our own custom media picker. 

 ### Architecture

<img width="779" alt="Sept 20 Screenshot" src="https://github.com/user-attachments/assets/5c54e73e-9bed-4305-a11e-77238e494111">

## **Implementation**

Implementation of MediaPicker is really easy and simple. So in-order to present Media Picker we initially need to create a configuration for it. 

<img width="1001" alt="Sept 20 Screenshot from s3" src="https://github.com/user-attachments/assets/7f21254d-6793-4af4-bf17-d7e679c8fef5">


So there are two form of configuration in media picker. 


1. **MediaPicker System Config**

This involves the internal configuration required for Media Picker. We need to be very careful when selecting this configurations, since this would directly lead to app perfomance.


2. **MediaPicker Config**

MediaPicker config includes the System config along with basic configurations required for Media Picker. Eg: Selection Limit & Media types to fetch


Once you are done with the configuration, then you just need to present the MediaPicker. Now presentation of media picker includes two methods


1. **Delegation Based**

Here present the picker normally, and confirm to its delegate, and you will be able to use the necessary methods.

<img width="1001" alt="Sept 20 Screenshot from s3 (1)" src="https://github.com/user-attachments/assets/e80ba11b-25d5-4e73-b0a2-d5e2e74a8589">


> Make sure you go through the code and understand what are the different types of configurations 

2. **Completion Based**

Here an extension is written for MediaPicker, which can be directly used to present it

<img width="1001" alt="Sept 20 Screenshot (1)" src="https://github.com/user-attachments/assets/db8a17b9-89b5-4f4e-858a-a0f8da8e3f8b">

Now all you need to do is configure your code as per the need.


> In our codebase, implementation of MediaPicker is done via **DeviceImagePicker.** So there is no need of direct implementation of the same.


## Under the hood ⚙️

Lets understand how under the hood Media Picker works with the following flow chart:

<img width="1624" alt="Sept 20 Screenshot from s3 (2)" src="https://github.com/user-attachments/assets/4253712d-5b5c-4d96-af4c-c8a966994984">

Initially Media Picker check for the **Authorisation** **status**, accordingly it takes the action. 
If Request is granted then the **MPStoreManager** will fetch all the assets and start rendering.
If request is not determined then it will ask for permission and finally if access is **restricted** it will throw error. 

