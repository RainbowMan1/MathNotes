//
//  EquationSnip.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationSnip.h"
#import "APIManager.h"
#import "SharedEquationSnip.h"

@implementation EquationSnip

@dynamic equationSnipID;
@dynamic equationSnipName;
@dynamic author;
@dynamic equationImage;
@dynamic htmlcode;
@dynamic laTeXcode;
@dynamic confidence;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic shared;

+ (nonnull NSString *)parseClassName {
    return @"EquationSnips";
}

+ (void) postEquationSnip:(NSString * _Nonnull)name withImage:(UIImage * _Nonnull) image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    EquationSnip *newEquationSnip = [EquationSnip new];
    newEquationSnip.author = [PFUser currentUser];
    newEquationSnip.equationSnipName = name;
    newEquationSnip.equationImage = [self getPFFileFromImage:image];
    [APIManager getLatexCodeForImage:image withSuccessCompletion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"text"]);
        NSLog(@"%@",responseObject[@"latex_styled"]);
        NSLog(@"%@",responseObject[@"confidence"]);
        
        newEquationSnip.htmlcode = [responseObject[@"text"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        newEquationSnip.laTeXcode =[responseObject[@"latex_styled"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        if (newEquationSnip.laTeXcode == nil && newEquationSnip.htmlcode!= nil){
            newEquationSnip.laTeXcode =  [[[[[[@"\\text{" stringByAppendingString:newEquationSnip.htmlcode] stringByReplacingOccurrencesOfString:@"\\(" withString:@"} $"] stringByReplacingOccurrencesOfString:@"\\)" withString:@"$ \\text{"] stringByReplacingOccurrencesOfString:@"\\[" withString:@"} $$"] stringByReplacingOccurrencesOfString:@"\\]" withString:@"$$ \\text{"]stringByAppendingString:@"}"];
            NSLog(@"%@",newEquationSnip.laTeXcode);
        }
        newEquationSnip.confidence = responseObject[@"confidence"];
        [newEquationSnip saveInBackgroundWithBlock: completion];
    }];
}

+ (void) updateEquationSnip:(EquationSnip * _Nonnull)equationSnip withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    [equationSnip saveInBackgroundWithBlock:completion];
}

+ (void)deleteEquationSnip:(EquationSnip * _Nonnull)equationSnip withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    if ([equationSnip.author.username isEqualToString:[PFUser currentUser].username]){
        PFQuery *query = [PFQuery queryWithClassName:@"SharedEquationSnips"];
        [query whereKey:@"sharedEquationSnip" equalTo:equationSnip];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sharedEquationSnips, NSError * _Nullable error) {
            for (SharedEquationSnip *sharedEquationSnip in sharedEquationSnips){
                [sharedEquationSnip deleteInBackground];
            }
            [equationSnip deleteInBackgroundWithBlock:completion];
        }];
    }
    else{
        [SharedEquationSnip deleteSharedEquationSnip:equationSnip withCompletion:completion];
    }
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
    return [PFFileObject fileObjectWithName:@"image.jpg" data:imageData];
}

@end



