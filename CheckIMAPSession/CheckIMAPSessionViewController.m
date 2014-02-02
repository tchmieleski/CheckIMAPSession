//
//  CheckIMAPSessionViewController.m
//  CheckIMAPSession
//
//  Created by Troy Chmieleski on 2/2/14.
//  Copyright (c) 2014 Troy Chmieleski. All rights reserved.
//

#import "CheckIMAPSessionViewController.h"
#import <Mailcore/Mailcore.h>

@interface CheckIMAPSessionViewController ()

@end

@implementation CheckIMAPSessionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self checkIMAPSession];
}

- (void)checkIMAPSession {
	MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    [session setHostname:@"imap.gmail.com"];
    [session setPort:993];
    [session setUsername:@"ADDRESS@gmail.com"];
    [session setPassword:@"123456"];
    [session setConnectionType:MCOConnectionTypeTLS];
	
	MCOIMAPOperation *checkAccountOperation = [session checkAccountOperation];
	
	// check IMAP session
	[checkAccountOperation start:^(NSError *error) {
		if (!error) {
			// if IMAP session is valid, proceed
			MCOIMAPOperation *noopOperation = [session noopOperation];
			
			[noopOperation start:^(NSError *error) {
				if (!error) {
					// check IMAP session
					MCOIMAPOperation *checkAccountOperation = [session checkAccountOperation];
					
					[checkAccountOperation start:^(NSError *error) {
						if (!error) {
							// if IMAP session is valid, proceed
							MCOIMAPOperation *noopOperation = [session noopOperation];
							
							[noopOperation start:^(NSError *error) {
								if (!error) {
									NSLog(@"Success!");
								}
								
								else {
									NSLog(@"Second noopOperation failed: %@", error);
								}
							}];
						}
						
						else {
							NSLog(@"Error: Could not validate IMAP session: %@", error);
						}
					}];
				}
				
				else {
					NSLog(@"Error: First noopOperation failed: %@", error);
				}
			}];
		}
		
		else {
			NSLog(@"Error: Could not validate IMAP session: %@", error);
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
