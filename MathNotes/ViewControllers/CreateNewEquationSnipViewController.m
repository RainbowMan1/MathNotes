//
//  CreateNewEquationSnipViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/21/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "CreateNewEquationSnipViewController.h"
#import "EquationSnip.h"
#import "TOCropViewController.h"
#import <Vision/Vision.h>

@interface CreateNewEquationSnipViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *snipNameField;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation CreateNewEquationSnipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    [self.imagePicker setDelegate:self];
    // Do any additional setup after loading the view.
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTap:(id)sender {
    [self.snipNameField endEditing:YES];
}

- (IBAction)continue:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add Equation Image"
                                                                                  message: @"Do you want to use camera or pick from library?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self equationFromCamera];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           [self equationFromLibrary];
       }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)equationFromLibrary{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)equationFromCamera {
    self.imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    VNImageRequestHandler *requestHandler = [[VNImageRequestHandler alloc] initWithCGImage:originalImage.CGImage orientation:[self getOrientation:originalImage.imageOrientation] options:@{}];
//    VNDetectTextRectanglesRequest *rectangleDetector= [[VNDetectTextRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
//        if (error){
//            NSLog(@"%@",@"YES");
//        }
//        else {
////            UIImage *newImage = [UIImage imageWithData:UIImageJPEGRepresentation(originalImage, 1)];
////            newImage = [self drawRectangleOnImage:originalImage rect:request.results];
//                for (VNTextObservation *textObservation in request.results) {
//                    NSLog(@"%@", textObservation.boundingBox);
//    //                NSLog(@"%@", textObservation.characterBoxes);
////                    NSLog(@"%@", NSStringFromCGRect(VNImageRectForNormalizedRect(textObservation.boundingBox,(int) roundf(originalImage.size.width),(int) roundf(originalImage.size.height))));
//
//                }
//
//
//            }
//        }];
//    rectangleDetector.reportCharacterBoxes = NO;
//    NSError *error;
//    [requestHandler performRequests:@[rectangleDetector] error:&error];
//    if (error) {
//        NSLog(@"%@", error);
//    }
    [self presentCropViewController:originalImage];
}



- (CGImagePropertyOrientation) getOrientation:(UIImageOrientation)uiOrientation{
        switch (uiOrientation) {
            case UIImageOrientationUp: return kCGImagePropertyOrientationUp;
            case UIImageOrientationDown: return kCGImagePropertyOrientationDown;
            case UIImageOrientationLeft: return kCGImagePropertyOrientationLeft;
            case UIImageOrientationRight: return kCGImagePropertyOrientationRight;
            case UIImageOrientationUpMirrored: return kCGImagePropertyOrientationUpMirrored;
            case UIImageOrientationDownMirrored: return kCGImagePropertyOrientationDownMirrored;
            case UIImageOrientationLeftMirrored: return kCGImagePropertyOrientationLeftMirrored;
            case UIImageOrientationRightMirrored: return kCGImagePropertyOrientationRightMirrored;
        }
}
- (void)presentCropViewController:(UIImage*)image {
  
  TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
  cropViewController.delegate = self;
  [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [EquationSnip postEquationSnip:self.snipNameField.text withImage:image withCompletion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
