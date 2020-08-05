//
//  APIManager.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/17/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "APIManager.h"
#import "APIKeys.h"
#import "AFNetworking.h"

static NSString  const *baseURLString = @"https://api.mathpix.com/";

@interface APIManager()

@end

@implementation APIManager

+ (void)getLatexCodeForImage:(UIImage*) image withSuccessCompletion:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successCompletion{
    NSString *endpoint = @"v3/text";
    NSString *urlString = [baseURLString stringByAppendingString:endpoint];
    
    
    NSString *base = [UIImageJPEGRepresentation(image, 0) base64EncodedStringWithOptions:0];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    [requestBody setValue:[@"data:image/jpeg;base64," stringByAppendingString:base] forKey:@"src"];
    NSMutableDictionary *dataOptions = [[NSMutableDictionary alloc] init];
    [dataOptions setValue:@YES forKey:@"include_latex"];
    [requestBody setValue:dataOptions forKey:@"data_options"];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"application/json" forKey:@"content-type"];
    [header setValue:APPId forKey:@"app_id"];
    [header setValue:APPKey forKey:@"app_key"];
    
    AFHTTPSessionManager *session = [APIManager getSessionManager];
    [session POST:urlString parameters:requestBody headers:header progress:nil success:successCompletion
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}
+(AFHTTPSessionManager*) getSessionManager{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
}

@end
