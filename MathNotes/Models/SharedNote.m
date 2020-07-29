//
//  SharedNotes.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/28/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedNote.h"

@implementation SharedNote

@dynamic sharedNote;
@dynamic sharedUser;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"SharedNotes";
}

+ (void) shareNote:(Note * _Nonnull)note withUsername:(NSString * _Nonnull)name withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    if (!([name isEqualToString:note.author.username])){
        SharedNote *share = [SharedNote new];
        share.sharedNote =note;
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

+ (void)deleteSharedNote:(Note *)note withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"SharedNotes"];
    [query whereKey:@"sharedNote" equalTo:note];
    [query whereKey:@"sharedUser" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharedNotes, NSError * _Nullable error) {
        if (sharedNotes.count==1) {
            [sharedNotes[0] deleteInBackgroundWithBlock:completion];
        }
    }];
}


@end
