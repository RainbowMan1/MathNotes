//
//  APIManager.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/17/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#ifndef APIManager_h
#define APIManager_h

#import <Foundation/Foundation.h>
#import "EquationSnip.h"

@interface APIManager :NSObject
+ (void)getLatexCodeForImage:(UIImage* _Nonnull) image withSuccessCompletion:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successCompletion;
@end

#endif /* APIManager_h */
