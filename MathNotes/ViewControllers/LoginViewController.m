//
//  ViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import <PFFacebookUtils.h>


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
- (IBAction)loginWithFacebook:(id)sender {
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error) {
      if (!user) {
        NSLog(@"Uh oh. The user cancelled the Facebook login.");
      } else if (user.isNew) {
        NSLog(@"User signed up and logged in through Facebook!");
          FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
              initWithGraphPath:@"/me"
                     parameters:@{ @"fields": @"id,email",}
                     HTTPMethod:@"GET"];
          [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
              if (!error) {
                  NSLog(@"%@", result[@"id"]);
                  user[@"FBID"] = result[@"id"];
                  user[@"email"] = result[@"email"];
                  user[@"username"] = [[[[result[@"email"] componentsSeparatedByString:@"@"][1] substringToIndex:1] stringByAppendingString:@"_"] stringByAppendingString:[result[@"email"] componentsSeparatedByString:@"@"][0]];
                
                  [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                      if (!error)
                          NSLog(@"Save was complete");
                  }];

                  [self performSegueWithIdentifier:@"firstSegue" sender:nil];
              }
          }];
          
      } else {
        NSLog(@"User logged in through Facebook!");
          [self performSegueWithIdentifier:@"firstSegue" sender:nil];
      }
    }];
}

@end
