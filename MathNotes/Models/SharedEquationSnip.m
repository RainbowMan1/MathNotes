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
        SharedEquationSnip *share = [SharedEquationSnip new];
        share.sharedEquationSnip =equationSnip;
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:name];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
            if (users.count==1) {
                NSLog(@"%@",@"found");
                NSLog(@"%@",users[0]);
                share.sharedUser = users[0];
                [share saveInBackgroundWithBlock: completion];
            }
            else{
                NSLog(@"%@",@"notfound");
            }
        }];
    }
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
