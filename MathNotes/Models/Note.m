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

@implementation Note

@dynamic noteID;
@dynamic noteName;
@dynamic author;
@dynamic htmlText;
@dynamic createdAt;
@dynamic updatedAt;

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
    note.author = [PFUser currentUser];
    [note saveInBackgroundWithBlock:completion];
}

@end
