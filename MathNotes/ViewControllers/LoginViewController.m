//
//  ViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passwordField.secureTextEntry = YES;
}
- (IBAction)logIn:(id)sender {
    if ([self checkInput]){
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                [self displayError:error.localizedDescription];
            } else {
                [self performSegueWithIdentifier:@"firstSegue" sender:nil];
                
                // display view controller that needs to shown after successful login
            }
        }];
    }
}

- (IBAction)signUp:(id)sender {
    if ([self checkInput]){
    PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                [self displayError:error.localizedDescription];
            } else {
                [self performSegueWithIdentifier:@"firstSegue" sender:nil];
                
                // manually segue to logged in view
            }
        }];
    }
}

-(void)displayError:(NSString*) errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Occured."
                                                                   message:errorMessage
    preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (BOOL) checkInput{
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString: @""]){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid username or password."
           message:@"Please try again."
    preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:^{
        
    }];
        return NO;
    }
    return YES;
}

@end
