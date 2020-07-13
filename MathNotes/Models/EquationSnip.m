//
//  EquationSnip.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationSnip.h"

@implementation EquationSnip

@dynamic equationSnipID;
@dynamic equationSnipName;
@dynamic author;
@dynamic equationImage;
@dynamic laTeXcode;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"EquationSnips";
}

+ (void) postEquationSnip:(NSString * _Nonnull)name withImage:(UIImage * _Nonnull) image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    EquationSnip *newEquationSnip = [EquationSnip new];
    newEquationSnip.equationSnipName = name;
    newEquationSnip.equationImage = [self getPFFileFromImage:image];
    
    [newEquationSnip saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.jpeg" data:imageData];
}

@end



