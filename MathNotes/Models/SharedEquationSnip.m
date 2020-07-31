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
    [query whereKey:@"sharedUser" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharedEquationSnips, NSError * _Nullable error) {
        if (sharedEquationSnips.count==1) {
            [sharedEquationSnips[0] deleteInBackgroundWithBlock:completion];
        }
    }];
}

@end
