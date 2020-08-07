//
//  SharedEquationSnip.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/28/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedEquationSnip.h"

@implementation SharedEquationSnip

@dynamic sharedEquationSnip;
@dynamic sharedUser;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"SharedEquationSnips";
}

+ (void) shareEquationSnip:(EquationSnip *)equationSnip withUsername:(NSString *)name withCompletion:(PFBooleanResultBlock)completion{
    if (!([name isEqualToString:equationSnip.author.username])){
        
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:name];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
            if (!error && users.count==1) {
                NSLog(@"%@",@"found");
                NSLog(@"%@",users[0]);
                PFQuery *shareNoteQuery= [PFQuery queryWithClassName:@"SharedEquationSnips"];
                [shareNoteQuery whereKey:@"sharedEquationSnip" equalTo:equationSnip];
                [shareNoteQuery whereKey:@"sharedUser" equalTo:users[0]];
                [shareNoteQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharenotes, NSError * _Nullable error) {
                    if (!error && sharenotes.count == 0){
                        SharedEquationSnip *share = [SharedEquationSnip new];
                        share.sharedEquationSnip =equationSnip;
                        share.sharedUser = users[0];
                        [share saveInBackgroundWithBlock: completion];
                        equationSnip.shared = YES;
                        [equationSnip saveInBackground];
                    }
                    else{
                        NSLog(@"%@",@"equation snip already shared to the user");
                    }
                }];
            }
            else{
                NSLog(@"%@",@"notfound");
            }
        }];
    }
}

+ (void) shareEquationSnip:(EquationSnip * _Nonnull)equationSnip withFBID:(NSString * _Nonnull)FBID withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"FBID" equalTo:FBID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if (!error && users.count==1){
            PFQuery *shareNoteQuery= [PFQuery queryWithClassName:@"SharedEquationSnips"];
            [shareNoteQuery whereKey:@"sharedEquationSnip" equalTo:equationSnip];
            [shareNoteQuery whereKey:@"sharedUser" equalTo:users[0]];
            [shareNoteQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharenotes, NSError * _Nullable error) {
                if (!error && sharenotes.count == 0){
                    SharedEquationSnip *share = [SharedEquationSnip new];
                    share.sharedEquationSnip =equationSnip;
                    share.sharedUser = users[0];
                    [share saveInBackgroundWithBlock: completion];
                    equationSnip.shared = YES;
                    [equationSnip saveInBackground];
                }
                else{
                    NSLog(@"%@",@"note already shared to the user");
                }
            }];
        }
        else{
            NSLog(@"%@",@"not found");
        }
    }];
}

+ (void)deleteSharedEquationSnip:(EquationSnip *)equationSnip withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"SharedEquationSnips"];
    [query whereKey:@"sharedEquationSnip" equalTo:equationSnip];
    [query includeKey:@"sharedUser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharedEquationSnips, NSError * _Nullable error) {
        if (sharedEquationSnips.count == 1){
            equationSnip.shared = NO;
            [equationSnip saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    [sharedEquationSnips[0] deleteInBackgroundWithBlock:completion];
                }
            }];
        }
        else{
            for (SharedEquationSnip *sharedSnip in sharedEquationSnips){
                if ([sharedSnip.sharedUser.username isEqualToString:[PFUser currentUser].username]){
                    [sharedSnip deleteInBackgroundWithBlock:completion];
                }
            }
        }
    }];
}

+ (void)deleteSharedEquationSnip:(EquationSnip *)equationSnip forUser:(PFUser *)user withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    if ([equationSnip.author.username isEqualToString:[PFUser currentUser].username]){
        PFQuery *query = [PFQuery queryWithClassName:@"SharedEquationSnips"];
        [query whereKey:@"sharedEquationSnip" equalTo:equationSnip];
        [query includeKey:@"sharedUser"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharedEquationSnips, NSError * _Nullable error) {
             if (sharedEquationSnips.count == 1){
                       equationSnip.shared = NO;
                       [equationSnip saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                           if (succeeded){
                               [sharedEquationSnips[0] deleteInBackgroundWithBlock:completion];
                           }
                       }];
                   }
             else if (sharedEquationSnips.count>1){
               for (SharedEquationSnip *sharedEquationSnip in sharedEquationSnips){
                   if ([sharedEquationSnip.sharedUser.username isEqualToString:user.username]){
                       [sharedEquationSnip deleteInBackgroundWithBlock:completion];
                   }
               }
           }
        }];
    }
}

@end
