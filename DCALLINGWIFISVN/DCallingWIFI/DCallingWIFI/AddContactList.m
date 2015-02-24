//
//  AddContactList.m
//  DCalling WiFi
//
//  Created by Prashant Kumar on 22/03/12.
//  Copyright (C) 2015 DALASON GmbH.
//  This file is part of a DALASON Project. (http://www.dalason.de)
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//

#import "AddContactList.h"
#import "KeypadViewController.h"

@implementation AddContactList

@synthesize callNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   /* callNumber = @"09887998978";
    [self getAddContact];
    
    [super viewDidLoad];
    UIImage *buttonImage = [UIImage imageNamed:@"call.png"];
     
     //create the button and assign the image
     backButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [backButton setImage:buttonImage forState:UIControlStateNormal];
     
     //set the frame of the button to the size of the image (see note below)
     backButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
     
     [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
     
     //create a UIBarButtonItem with the button as a custom view
     UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
     self.navigationItem.leftBarButtonItem = customBarItem;
     
     // Cleanup
     [customBarItem release]; 
    
	// Do any additional setup after loading the view.*/
}


- (void)viewDidUnload
{
    // Set the custom back button
	
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void) getAddContact{
    
  /*  ABRecordRef aContact = ABPersonCreate();
	CFErrorRef anError = NULL;
    
	ABMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	bool didAdd = ABMultiValueAddValueAndLabel(email, callNumber, kABPersonPhoneMobileLabel, NULL);
	
	if (didAdd == YES)
	{
		ABRecordSetValue(aContact, kABPersonPhoneProperty, email, &anError);
		if (anError == NULL)
		{
			ABUnknownPersonViewController *picker = [[ABUnknownPersonViewController alloc] init];
			picker.unknownPersonViewDelegate = self;
			picker.displayedPerson = aContact;
			picker.allowsAddingToAddressBook = YES;
		    picker.allowsActions = NO;
            //[self.view addSubview:backButton];
			//picker.alternateName = @"John Appleseed";
			//picker.title = @"John Appleseed";
			//picker.message = @"Company, Inc";
            
			[self.navigationController pushViewController:picker animated:YES];
			[picker release];
		}
		else 
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
															message:@"Could not create unknown user" 
														   delegate:nil 
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}	
	CFRelease(email);
	CFRelease(aContact);*/
}

/*- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
	[self dismissModalViewControllerAnimated:YES];
    
}


// Does not allow users to perform default actions such as emailing a contact, when they select a contact property.
- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person 
						   property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return YES;
}*/


-(void) dealloc{
    
   
    [super dealloc];
}



@end
