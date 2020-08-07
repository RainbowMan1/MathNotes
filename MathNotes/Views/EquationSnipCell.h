//
//  EquationSnipCell.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquationSnip.h"

NS_ASSUME_NONNULL_BEGIN
@protocol EquationSnipCellDelegate

- (void) didTapRename:(EquationSnip *)equationSnip withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void) didTapShare:(EquationSnip *)equationSnip withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void) presentSharedUserControllerWithEquationSnip:(EquationSnip *) equationSnip;

@end

@interface EquationSnipCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *renameView;
@property (weak, nonatomic) IBOutlet UILabel *equationSnipName;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownedImage;
@property (weak, nonatomic) IBOutlet UIView *ownerColorView;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) EquationSnip *equationSnip;
@property (weak, nonatomic) id<EquationSnipCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
