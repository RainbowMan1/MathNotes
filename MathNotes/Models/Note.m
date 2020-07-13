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

@implementation Note

@dynamic noteID;
@dynamic noteName;
@dynamic author;
@dynamic text;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"Notes";
}

+ (void) postNote: (NSString * _Nonnull)name withText: (NSString * _Nullable)text withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Note *newNote = [Note new];
    newNote.noteName = name;
    newNote.text = text;
    
    [newNote saveInBackgroundWithBlock: completion];
}

@end
