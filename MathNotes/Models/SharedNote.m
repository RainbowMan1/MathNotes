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
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:name];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
            if (!error && users.count==1) {
                PFQuery *shareNoteQuery= [PFQuery queryWithClassName:@"SharedNotes"];
                [shareNoteQuery whereKey:@"sharedNote" equalTo:note];
                [shareNoteQuery whereKey:@"sharedUser" equalTo:users[0]];
                [shareNoteQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharenotes, NSError * _Nullable error) {
                    if (!error && sharenotes.count == 0){
                        SharedNote *share = [SharedNote new];
                        share.sharedNote =note;
                        share.sharedUser = users[0];
                        [share saveInBackgroundWithBlock: completion];
                        note.shared = YES;
                        [note saveInBackground];
                    }
                    else{
                        NSLog(@"%@",@"note already shared to the user");
                    }
                }];
                
            }
            else{
                NSLog(@"%@",@"notfound");
            }
        }];
    }
}

+ (void) shareNote:(Note * _Nonnull)note withFBID:(NSString * _Nonnull)FBID withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"FBID" equalTo:FBID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if (!error && users.count==1){
            PFQuery *shareNoteQuery= [PFQuery queryWithClassName:@"SharedNotes"];
            [shareNoteQuery whereKey:@"sharedNote" equalTo:note];
            [shareNoteQuery whereKey:@"sharedUser" equalTo:users[0]];
            [shareNoteQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharenotes, NSError * _Nullable error) {
                if (!error && sharenotes.count == 0){
                    SharedNote *share = [SharedNote new];
                    share.sharedNote =note;
                    share.sharedUser = users[0];
                    [share saveInBackgroundWithBlock: completion];
                    note.shared = YES;
                    [note saveInBackground];
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

+ (void)deleteSharedNote:(Note *)note withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"SharedNotes"];
    [query whereKey:@"sharedNote" equalTo:note];
    [query includeKey:@"sharedUser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharedNotes, NSError * _Nullable error) {
         if (sharedNotes.count == 1){
                   note.shared = NO;
                   [note saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                       if (succeeded){
                           [sharedNotes[0] deleteInBackgroundWithBlock:completion];
                       }
                   }];
               }
         else if (sharedNotes.count>1){
           for (SharedNote *sharedNote in sharedNotes){
               if ([sharedNote.sharedUser.username isEqualToString:[PFUser currentUser].username]){
                   [sharedNote deleteInBackgroundWithBlock:completion];
               }
           }
       }
    }];
}

+ (void)deleteSharedNote:(Note *)note forUser:(PFUser *)user withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    if ([note.author.username isEqualToString:[PFUser currentUser].username]){
        PFQuery *query = [PFQuery queryWithClassName:@"SharedNotes"];
        [query whereKey:@"sharedNote" equalTo:note];
        [query includeKey:@"sharedUser"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharedNotes, NSError * _Nullable error) {
             if (sharedNotes.count == 1){
                       note.shared = NO;
                       [note saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                           if (succeeded){
                               [sharedNotes[0] deleteInBackgroundWithBlock:completion];
                           }
                       }];
                   }
             else if (sharedNotes.count>1){
               for (SharedNote *sharedNote in sharedNotes){
                   if ([sharedNote.sharedUser.username isEqualToString:user.username]){
                       [sharedNote deleteInBackgroundWithBlock:completion];
                   }
               }
           }
        }];
    }
}


@end
