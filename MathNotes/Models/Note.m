//
//  Note.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

//
//  Post.m
//  Instagram
//
//  Created by Nikesh Subedi on 7/7/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//


#import "Note.h"
#import "Parse/Parse.h"
#import "SharedNote.h"

@implementation Note

@dynamic noteID;
@dynamic noteName;
@dynamic author;
@dynamic htmlText;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic shared;

+ (nonnull NSString *)parseClassName {
    return @"Notes";
}

+ (void) postNote: (NSString * _Nonnull)name withText: (NSString * _Nullable)html withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Note *newNote = [Note new];
    newNote.author = [PFUser currentUser];
    newNote.noteName = name;
    newNote.htmlText = html;

    [newNote saveInBackgroundWithBlock: completion];
}

+ (void) updateNote:(Note * _Nonnull)note withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    [note saveInBackgroundWithBlock:completion];
}

+ (void)deleteNote:(Note * _Nonnull)note withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    if ([note.author.username isEqualToString:[PFUser currentUser].username]){
        PFQuery *query = [PFQuery queryWithClassName:@"SharedNotes"];
        [query whereKey:@"sharedNote" equalTo:note];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharedNotes, NSError * _Nullable error) {
            for (SharedNote *sharedNote in sharedNotes){
                [sharedNote deleteInBackground];
            }
            [note deleteInBackgroundWithBlock:completion];
        }];
    }
    else{
        [SharedNote deleteSharedNote:note withCompletion:completion];
    }
}

+ (Note * _Nonnull)getNewNote{
    Note *newNote = [Note new];
        newNote.author = [PFUser currentUser];
        newNote.noteName = @"Untitled Note";
    return newNote;
}

@end
