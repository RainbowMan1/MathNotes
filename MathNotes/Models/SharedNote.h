//
//  SharedNotes.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/28/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#ifndef SharedNotes_h
#define SharedNotes_h
#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Note.h"

@interface SharedNote : PFObject<PFSubclassing>

@property (nonatomic, strong) Note * _Nonnull sharedNote;
@property (nonatomic, strong) PFUser * _Nonnull sharedUser;
@property (nonatomic, strong, readonly) NSDate * _Nonnull createdAt;
@property (nonatomic, strong, readonly) NSDate * _Nonnull updatedAt;

+ (void) shareNote:(Note * _Nonnull)note withUsername:(NSString * _Nonnull)name withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

#endif /* SharedNotes_h */
