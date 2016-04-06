//
//  ViewController.m
//  ToDoList
//
//  Created by Admin on 06.04.16.
//  Copyright © 2016 Ehlakov Victor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonSave.userInteractionEnabled = NO;//блокировка кнопки
    
    self.datePicker.minimumDate = [NSDate date];//установка минимального значения
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.buttonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTouch)];
    [self.view addGestureRecognizer:touch];//добавили touch на экран
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) datePickerValueChanged {
    
    self.eventDate = self.datePicker.date;
    NSLog(@"%@", self.eventDate);
    
}

-(void) handleTouch {

    if ([self.textField.text length] != 0) {
        [self.view endEditing:YES];//закрывает любое текстовое поле
        self.buttonSave.userInteractionEnabled = YES;
    }
    
    else {
        [self showAlertWithMessage:@"Введи значения в текстовое поле"];
    }
    
    //[self.textField resignFirstResponder];сворачивает клавиатуру, для одного текстового поля


}

-(void) save {
    
    if (self.eventDate) {
        if ([self.eventDate compare:[NSDate date]] == NSOrderedSame) {
            [self showAlertWithMessage:@"Дата события не может совпадать с текущей датой"];
        }
        else if ([self.eventDate compare:[NSDate date]] == NSOrderedAscending) {
            [self showAlertWithMessage:@"Дата события не может быть ранее текущей даты"];
        }
        else {
            [self setNotification];
        }
    }
    
    else {
        [self showAlertWithMessage:@"Введи значения даты"];
    }
}

-(void) setNotification {
    NSString *eventInfo = self.textField.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm dd.MMMM.yyyy";
    NSString *eventDate = [formatter stringFromDate:self.eventDate];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:
                          eventInfo, @"eventInfo", eventDate, @"eventDate", nil];//что бы иметь доступ к данным объект = ключ
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    notification.userInfo = dict;//?
    notification.timeZone = [NSTimeZone defaultTimeZone];//часовой пояс
    notification.fireDate = self.eventDate;//дата когда прозвучит уведомление
    notification.alertBody = eventInfo;//текст который будет виден на заблокированом экране
    notification.applicationIconBadgeNumber = 1;//красная иконка уведомлений
    notification.soundName = UILocalNotificationDefaultSoundName;//звук при появлении уведомления
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];//добавления нотификации(напоминания) в мобильное приложение
    
    NSLog(@"Сохранить");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.textField]) {//проверка, что бы именно наше текстовое поле
        if ([self.textField.text length] != 0) {
            [self.textField resignFirstResponder];//сворачивает клавиатуру
            self.buttonSave.userInteractionEnabled = YES;
            return YES;
        }
     
        else {
            [self showAlertWithMessage:@"Введи значения в текстовое поле"];
        }
    }
    
    return NO;
}

-(void) showAlertWithMessage : (NSString*) message {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Внимание!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    
    
}
@end
