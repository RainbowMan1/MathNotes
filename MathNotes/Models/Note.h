//
//  Note.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#ifndef Note_h
#define Note_h

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
@interface Note : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString * _Nonnull noteID;
@property (nonatomic, strong) NSString * _Nonnull noteName;
@property (nonatomic, strong) PFUser * _Nonnull author;
@property (nonatomic, strong) NSString * _Nullable htmlText;
@property (nonatomic, strong, readonly) NSDate * _Nonnull createdAt;
@property (nonatomic, strong, readonly) NSDate * _Nonnull updatedAt;
@property (nonatomic) BOOL shared;

+ (void) postNote: (NSString * _Nonnull)name withText: (NSString * _Nullable)html withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) updateNote:(Note * _Nonnull)note withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void)deleteNote:(Note * _Nonnull)note withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (Note * _Nonnull)getNewNote;

@end


#endif /* Note_h */
