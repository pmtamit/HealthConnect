//
//  FilterView.m
//  HealthConnect
//
//  Created by John Nguyen on 3/27/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
//        UILabel *Country = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
//        Country.text = @"Country :";
//        [self addSubview:Country];
        
        UILabel *Gender = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
        Gender.text = @"Gender :";
        [self addSubview:Gender];
        
        UIButton  *female = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [female addTarget:self
                    action:@selector(chooseFemale)
          forControlEvents:UIControlEventTouchUpInside];
        [female setTitle:@"Female" forState:UIControlStateNormal];
        female.frame = CGRectMake(20, 35, 60, 30);
        female.tag = 1;
        female.backgroundColor =[UIColor grayColor];
        [self addSubview:female];
        
        UIButton  *Male = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [Male addTarget:self
                   action:@selector(chooseMale)
         forControlEvents:UIControlEventTouchUpInside];
        [Male setTitle:@"Male" forState:UIControlStateNormal];
        Male.frame = CGRectMake(100, 35, 60, 30);
        Male.tag = 2;
        Male.backgroundColor =[UIColor grayColor];
        [self addSubview:Male];
        
        
//        UILabel *Age = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 100, 20)];
//        Age.text = @"Age :";
//        [self addSubview:Age];

        UILabel *Patient = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 20)];
        Patient.text = @"Patient :";
        [self addSubview:Patient];
        
        UIButton  *yes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [yes addTarget:self
               action:@selector(chooseYes)
     forControlEvents:UIControlEventTouchUpInside];
        [yes setTitle:@"YES" forState:UIControlStateNormal];
        yes.frame = CGRectMake(20, 95, 60, 30);
        yes.tag = 3;
        yes.backgroundColor =[UIColor grayColor];
        [self addSubview:yes];
        
        UIButton  *no = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [no addTarget:self
                 action:@selector(chooseNo)
       forControlEvents:UIControlEventTouchUpInside];
        [no setTitle:@"NO" forState:UIControlStateNormal];
        no.frame = CGRectMake(100, 95, 60, 30);
        no.tag = 4;
        no.backgroundColor =[UIColor grayColor];
       [self addSubview:no];

        UIButton  *btApply = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btApply addTarget:self
               action:@selector(Filter)
     forControlEvents:UIControlEventTouchUpInside];
        [btApply setTitle:@"Filter" forState:UIControlStateNormal];
        btApply.frame = CGRectMake(20, 140, 150, 30);
        btApply.tag = 5;
        btApply.backgroundColor =[UIColor grayColor];
        [self addSubview:btApply];
        patient = @"";
        gender = @"";
    }
    return self ;

}
-(void)Filter{
    [_delegate clickFilterwithGender:gender withPatient:patient];
}
-(void)chooseYes{
    patient = @"YES";
}
-(void)chooseNo{
    patient = @"NO";
}
-(void)chooseFemale{
    gender = @"Female";
}
-(void)chooseMale{
    gender = @"Male";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
