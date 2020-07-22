//
//  EquationSnip.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#ifndef EquationSnip_h
#define EquationSnip_h
#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
@interface EquationSnip : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString * _Nonnull equationSnipID;
@property (nonatomic, strong) NSString * _Nonnull equationSnipName;
@property (nonatomic, strong) PFUser * _Nonnull author;
@property (nonatomic, strong) PFFileObject * _Nonnull equationImage;
@property (nonatomic, strong) NSString * _Nullable htmlcode;
@property (nonatomic, strong) NSString * _Nullable laTeXcode;
@property (nonatomic, strong) NSNumber * _Nullable confidence;
@property (nonatomic, strong, readonly) NSDate * _Nonnull createdAt;
@property (nonatomic, strong, readonly) NSDate * _Nonnull updatedAt;

+ (void) postEquationSnip:(NSString * _Nonnull)name withImage:(UIImage * _Nonnull) image withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

#endif /* EquationSnip_h */
