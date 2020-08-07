//
//  SharedEquationSnip.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/28/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#ifndef SharedEquationSnip_h
#define SharedEquationSnip_h
#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "EquationSnip.h"

@interface SharedEquationSnip : PFObject<PFSubclassing>

@property (nonatomic, strong) EquationSnip * _Nonnull sharedEquationSnip;
@property (nonatomic, strong) PFUser * _Nonnull sharedUser;
@property (nonatomic, strong, readonly) NSDate * _Nonnull createdAt;
@property (nonatomic, strong, readonly) NSDate * _Nonnull updatedAt;

+ (void) shareEquationSnip:(EquationSnip * _Nonnull)equationSnip withUsername:(NSString * _Nonnull)name withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) deleteSharedEquationSnip:(EquationSnip * _Nonnull)equationSnip withCompletion: (PFBooleanResultBlock  _Nullable)completion ;
+ (void) shareEquationSnip:(EquationSnip * _Nonnull)equationSnip withFBID:(NSString * _Nonnull)FBID withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void)deleteSharedEquationSnip:(EquationSnip * _Nonnull)equationSnip forUser:(PFUser * _Nonnull)user withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

#endif /* SharedEquationSnip_h */
