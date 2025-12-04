org 100h

.data
    ; Screen attributes and constants
    SCREEN_WIDTH equ 80
    SCREEN_HEIGHT equ 25
    SINGLE_LINE_BORDER equ 0C4h  ; Horizontal line
    DOUBLE_LINE_BORDER equ 0CDh  ; Double horizontal line
    VERTICAL_BORDER equ 0B3h      ; Vertical line
    DOUBLE_VERTICAL_BORDER equ 0BAh ; Double vertical line
    TOP_LEFT_CORNER equ 0C9h      ; Top left corner (double)
    TOP_RIGHT_CORNER equ 0BBh     ; Top right corner (double)
    BOTTOM_LEFT_CORNER equ 0C8h   ; Bottom left corner (double)
    BOTTOM_RIGHT_CORNER equ 0BCh  ; Bottom right corner (double)
    CROSS_JUNCTION equ 0CEh       ; Cross junction for tables
    
    ; Color attributes
    HEADER_COLOR equ 1Fh         ; Blue background, white text
    NORMAL_COLOR equ 07h         ; Black background, white text
    HIGHLIGHT_COLOR equ 2Fh      ; Green background, white text
    WARNING_COLOR equ 4Eh        ; Red background, yellow text
    INPUT_COLOR equ 17h          ; Blue background, white text
    MENU_COLOR equ 70h           ; White background, black text
    
    ; Title and header
    title_text db '*** AIRPLANE MANAGEMENT SYSTEM ***$'
    subtitle_text db 'Flight Management | Air Traffic Control | Fuel Monitoring$'

    ; Main menu options
    menu_title db 'MAIN MENU$'
    menu_option1 db '1. Flight Management$'
    menu_option2 db '2. Air Traffic Control$'
    menu_option3 db '3. Fuel Monitoring$'
    menu_option4 db '4. Exit$'
    menu_prompt db 'Enter your choice (1-4): $'

    ; Flight details prompts
    msg1 db 'Enter Flight Number: $'
    msg2 db 'Enter Destination: $'
    msg3 db 'Enter Departure Time (HH:MM): $'
    msg4 db 'Enter Starting Place: $'
    msg5 db 'Enter Initial Fuel (liters): $'
    output_msg db 'Flight Details Entered:-$'
    flight_label db 'Flight: $'
    destination_label db 'Destination: $'
    source_label db 'Source: $'
    time_label db 'Departure Time: $'
    arrival_label db 'Arrival: $'
    fuel_label db 'Fuel Level: $'
    multiple_flights_msg db 'Multiple flights detected! Displaying aircraft...$'

    ; Flight data buffers - expanded to store more information
    MAX_FLIGHTS equ 5
    flight_no db 10,?,10 dup('$')
    destination db 20,?,20 dup('$')  
    source db 20,?,20 dup('$')
    dep_time db 10,?,10 dup('$')
    travel_time dw 0
    fuel_level dw 1000 ; Default fuel level
    fuel_consumption dw 100 ; Fuel consumption per hour
    
    ; Flight database - can store multiple flights
    flight_database db MAX_FLIGHTS * 100 dup(0)
    
    ; Flight counter
    flight_count db 0
    
    ; Route definitions and travel times
    chennai_bangalore db 'Chennai-Bangalore$'
    chennai_coimbatore db 'Chennai-Coimbatore$'
    coimbatore_bangalore db 'Coimbatore-Bangalore$'
    
    ; Air traffic control variables
    runway_status db 0 ; 0 = free, 1 = occupied
    landing_queue db MAX_FLIGHTS dup(0) ; Queue for landing
    queue_size db 0
    
    ; Airplane graphics - enhanced with colors
    flight1_graphics DB  '              .------,', 0DH, 0AH
            DB  '              =\      \', 0DH, 0AH
            DB  ' .---.         =\      \', 0DH, 0AH
            DB  ' | C~ \         =\      \', 0DH, 0AH
            DB  ' |     `----------''------''----------,', 0DH, 0AH
            DB  '.''     LI.-.LI LI LI LI LI LI LI.-.LI`-.', 0DH, 0AH
            DB  '\ _/.____|_|______.------,______|_|_____)', 0DH, 0AH
            DB  '                 /      /', 0DH, 0AH
            DB  '               =/      /', 0DH, 0AH
            DB  '              =/      /', 0DH, 0AH
            DB  '             =/      /', 0DH, 0AH
            DB  '             /_____,''', 0DH, 0AH, '$'

    flight2_graphics DB  '    ____', 0DH, 0AH
            DB  '  |        | ___\          /~~~|', 0DH, 0AH
            DB  ' _:_______|/''(..)`\_______/  | |', 0DH, 0AH
            DB  '<_|``````  \__~~__/       ___|_|', 0DH, 0AH
            DB  '  :\_____(=========,   ,--\__|_/', 0DH, 0AH
            DB  '  |       \       /---''', 0DH, 0AH
            DB  '            |     /', 0DH, 0AH
            DB  '            |____/', 0DH, 0AH, '$'

    ; New radar graphics for air traffic control
    radar_graphics DB '         ___________         ', 0DH, 0AH
                  DB '        /           \        ', 0DH, 0AH
                  DB '       /     |       \       ', 0DH, 0AH
                  DB '      /               \      ', 0DH, 0AH
                  DB '     /       |         \     ', 0DH, 0AH
                  DB '    /                   \    ', 0DH, 0AH
                  DB '   /         |           \   ', 0DH, 0AH
                  DB '  /                       \  ', 0DH, 0AH
                  DB ' /           |              \ ', 0DH, 0AH
                  DB '/___________________________\', 0DH, 0AH, '$'

    ; Fuel gauge graphics
    fuel_gauge_full    DB '|||||||||||||||||||||$'
    fuel_gauge_empty   DB '                     $'
    
    ; Storage for arrival times
    flight1_arr_time db '00:00$'
    flight2_arr_time db '00:00$'
    
    ; Temporary buffers for time calculation
    hours db 0
    minutes db 0
    temp_buffer db 6 dup('$')
    
    ; UI elements
    hline_buffer db SCREEN_WIDTH dup(SINGLE_LINE_BORDER), '$'
    dline_buffer db SCREEN_WIDTH dup(DOUBLE_LINE_BORDER), '$'
    empty_line db SCREEN_WIDTH dup(' '), '$'
    another_flight_prompt db 'Enter another flight? (Y/N): $'
    
    ; Status messages
    calculating_msg db 'Calculating travel time...$'
    processing_msg db 'Processing your flight details...$'
    atc_msg db 'Air Traffic Control: Monitoring airspace...$'
    fuel_warning_msg db 'WARNING: Low fuel level detected!$'
    landing_request_msg db 'Landing request received. Processing...$'
    landing_cleared_msg db 'Landing clearance granted.$'
    landing_denied_msg db 'Landing clearance denied. Runway occupied.$'
    press_key_msg db 'Press any key to continue...$'

.code
start:
    ; Initialize screen
    call clear_screen
    call draw_fancy_header
    
    ; Display main menu
    call display_main_menu
    
    ; Exit program
    mov ah, 4Ch
    int 21h
                  
                  
                  
                  
                  
; Main menu procedure
display_main_menu proc
    ; Clear screen and draw header
    call clear_screen
    call draw_fancy_header
    
    ; Draw menu box
    mov dh, 5
    mov dl, 25
    call set_cursor
    
    ; Menu title with special color
    mov ah, 09h
    mov bl, MENU_COLOR
    mov cx, 30
    int 10h
    
    mov ah, 09h
    mov dx, offset menu_title
    int 21h
    
    ; Menu options
    mov dh, 7
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov dx, offset menu_option1
    int 21h
    
    mov dh, 9
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov dx, offset menu_option2
    int 21h
    
    mov dh, 11
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov dx, offset menu_option3
    int 21h
    
    mov dh, 13
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov dx, offset menu_option4
    int 21h
    
    ; Prompt for choice
    mov dh, 15
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov dx, offset menu_prompt
    int 21h
    
    ; Get user choice
    mov ah, 01h
    int 21h
    
    ; Process choice
    cmp al, '1'
    je flight_management
    cmp al, '2'
    je air_traffic_control
    cmp al, '3'
    je fuel_monitoring
    cmp al, '4'
    je exit_program
    
    ; Invalid choice, redisplay menu
    jmp display_main_menu
    
flight_management:
    call flight_management_module
    jmp display_main_menu
    
air_traffic_control:
    call air_traffic_control_module
    jmp display_main_menu
    
fuel_monitoring:
    call fuel_monitoring_module
    jmp display_main_menu
    
exit_program:
    ret
display_main_menu endp  






; Flight Management Module
flight_management_module proc
    ; Clear screen
    call clear_screen
    call draw_fancy_header
    
    ; Main program loop
    call input_flight_details
    
    ; Show processing message
    call draw_status_bar
    mov dx, offset processing_msg
    call display_status
    
    ; Continue with processing
    call calculate_travel_time
    
    ; Show calculating message
    mov dx, offset calculating_msg  
    call display_status
    
    call calculate_arrival_time
    
    ; Store arrival time
    cmp flight_count, 1
    je store_flight1_arrival
    
    ; Store flight 2 arrival time
    mov si, offset temp_buffer
    mov di, offset flight2_arr_time
    call copy_string
    jmp display_details
    
store_flight1_arrival:
    ; Store flight 1 arrival time
    mov si, offset temp_buffer
    mov di, offset flight1_arr_time
    call copy_string
    
display_details:
    call display_flight_details
    
    ; Ask if user wants to enter another flight
    call ask_for_another_flight
    
    ; If we have multiple flights, display the graphics
    cmp flight_count, 1
    jg display_airplanes
    
    ; Return to main menu
    ret       
    
    
    
    
    
    
display_airplanes:
    ; Clear screen and show airplane display
    call clear_screen
    call draw_fancy_header
    
    ; Display multiple flights message with a border
    mov ah, 09h
    mov dx, offset multiple_flights_msg
    int 21h
    
    call draw_horizontal_line
    
    ; Display flight1 with arrival time
    mov ah, 02h
    mov bh, 00h
    mov dh, 04h  ; Start a bit lower on screen
    mov dl, 02h
    int 10h
    
    ; Change color for airplane 1
    mov ah, 09h
    mov bl, 02h  ; Light green
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight1_graphics
    int 21h
    
    ; Display flight info next to airplane 1
    mov ah, 02h
    mov bh, 00h
    mov dh, 06h
    mov dl, 50h
    int 10h
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight_label
    int 21h
    
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight_no+2
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 07h
    mov dl, 50h
    int 10h
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset arrival_label
    int 21h
    
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight1_arr_time
    int 21h
    
    ; Display flight2 with arrival time
    mov ah, 02h
    mov bh, 00h
    mov dh, 18h
    mov dl, 02h
    int 10h
    
    ; Change color for airplane 2
    mov ah, 09h
    mov bl, 0Eh  ; Yellow
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight2_graphics
    int 21h
    
    ; Display flight info next to airplane 2
    mov ah, 02h
    mov bh, 00h
    mov dh, 19h
    mov dl, 50h
    int 10h
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight_label
    int 21h
    
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight_no+2
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 20h
    mov dl, 50h
    int 10h
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset arrival_label
    int 21h
    
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight2_arr_time
    int 21h
    
    ; Draw footer
    call draw_status_bar
    
    mov dx, offset press_key_msg
    call display_status
    
    ; Wait for key press before returning
    mov ah, 00h
    int 16h
                 
              
    ret       
    
    
    
    
    
    
    
    
flight_management_module endp

; Air Traffic Control Module


air_traffic_control_module proc
    ; Clear screen
    call clear_screen
    call draw_fancy_header
    
    ; Display ATC title
    mov dh, 3
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov bl, HEADER_COLOR
    mov cx, 30
    int 10h
    
    mov ah, 09h
    mov dx, offset atc_title
    int 21h
    
    ; Display radar
    mov dh, 5
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov bl, 0Ah  ; Light green
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset radar_graphics
    int 21h
    
    ; Initialize runway status to free (0)
    mov runway_status, 0
    
    ; Only check for conflicts if we have multiple flights
    cmp flight_count, 1
    jle skip_conflict_check
    
    ; We have multiple flights, check for conflicts
    ; Compare arrival times
    mov si, offset flight1_arr_time
    mov di, offset flight2_arr_time
    call compare_arrival_times
    jnc check_destinations  ; If times are not close, check destinations
    
    ; Arrival times are close - set runway as occupied
    mov runway_status, 1
    jmp display_runway_status
    
check_destinations:
    ; Now check if destinations are the same
    ; FIXED: Compare the destinations of different flights properly
    
    ; Load the addresses of the different flight destinations
    mov si, offset flight1_destination+2  ; First flight destination
    mov di, offset flight2_destination+2  ; Second flight destination
    
    ; Compare the first character of each destination
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne skip_conflict_check  ; If destinations are different, no conflict
    
    ; Destinations have the same first character, check the second character
    mov al, [si+1]
    mov bl, [di+1]
    cmp al, bl
    jne skip_conflict_check  ; If second characters are different, no conflict
    
    ; Destinations appear to be the same, mark runway as occupied
    mov runway_status, 1
    jmp display_runway_status
    
skip_conflict_check:
    ; Continue with normal processing
    
display_runway_status:
    ; Display runway status
    mov dh, 16
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset runway_status_label
    int 21h
    
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    ; Check runway status
    cmp runway_status, 0
    jne runway_occupied
    
    ; Runway is free
    mov ah, 09h
    mov dx, offset runway_free_msg
    int 21h
    jmp check_landing_requests
    
runway_occupied:
    ; Runway is occupied
    mov ah, 09h
    mov bl, WARNING_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset runway_occupied_msg
    int 21h
    
    ; Display conflict message
    mov dh, 17
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov bl, WARNING_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset runway_conflict_msg
    int 21h
    
check_landing_requests:
    ; Simulate landing request
    call simulate_landing_request
    
    ; Display landing queue
    mov dh, 18
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset landing_queue_label
    int 21h
    
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 02h          ; Function to output a character
    mov dl, queue_size   ; Get the queue size
    add dl, '0'          ; Convert to ASCII
    int 21h              ; Display the character
    
    ; Process landing requests
    call process_landing_requests
    
    ; Draw footer
    call draw_status_bar
    
    mov dx, offset press_key_msg
    call display_status
    
    ; Wait for key press before returning
    mov ah, 00h
    int 16h
    
    ret
air_traffic_control_module endp







; Compare arrival times to see if they are within 15 minutes of each other
compare_arrival_times proc
    push ax
    push bx
    
    ; Parse first time
    mov al, [si]      ; Hours tens digit
    sub al, '0'
    mov bl, 10
    mul bl
    mov bl, [si+1]    ; Hours units digit
    sub bl, '0'
    add al, bl        ; AL = hours
    
    mov bl, 60
    mul bl            ; AX = hours in minutes
    
    mov bl, [si+3]    ; Minutes tens digit
    sub bl, '0'
    mov cx, 10
    mul cx
    mov bl, [si+4]    ; Minutes units digit
    sub bl, '0'
    add ax, bx        ; AX = total minutes for first time
    
    mov bx, ax        ; Save first time in BX
    
    ; Parse second time
    mov al, [di]      ; Hours tens digit
    sub al, '0'
    mov cl, 10
    mul cl
    mov cl, [di+1]    ; Hours units digit
    sub cl, '0'
    add al, cl        ; AL = hours
    
    mov cl, 60
    mul cl            ; AX = hours in minutes
    
    mov cl, [di+3]    ; Minutes tens digit
    sub cl, '0'
    mov ch, 10
    mul ch
    mov cl, [di+4]    ; Minutes units digit
    sub cl, '0'
    add ax, cx        ; AX = total minutes for second time
    
    ; Calculate difference
    sub ax, bx
    jns positive_diff
    neg ax            ; Take absolute value
    
positive_diff:
    ; Compare if within 15 minutes
    cmp ax, 15
    jle times_close
    
    clc               ; Clear carry flag - times not close
    jmp end_compare
    
times_close:
    stc               ; Set carry flag - times are close
    
end_compare:
    pop bx
    pop ax
    ret
compare_arrival_times endp

; Add new message for runway conflict
runway_conflict_msg db 'Warning: Multiple flights with same destination/arrival time!$'







; Fuel Monitoring Module
fuel_monitoring_module proc
    ; Clear screen
    call clear_screen
    call draw_fancy_header
    
    ; Display fuel monitoring title
    mov dh, 3
    mov dl, 25
    call set_cursor
    
    mov ah, 09h
    mov bl, HEADER_COLOR
    mov cx, 30
    int 10h
    
    mov ah, 09h
    mov dx, offset fuel_title
    int 21h
    
    ; Display fuel levels for each flight
    mov dh, 5
    mov dl, 10
    call set_cursor
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight_label
    int 21h
    
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight_no+2
    int 21h
    
    ; Display fuel gauge
    mov dh, 7
    mov dl, 10
    call set_cursor
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset fuel_label
    int 21h
    
    ; Calculate and display fuel percentage
    mov ax, fuel_level
    mov bx, 1000  ; Max fuel
    mov cx, 100
    mul cx
    div bx        ; AX = fuel percentage
    
    ; Convert percentage to ASCII
    mov bx, 10
    mov cx, 0
    
convert_loop:
    mov dx, 0
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert_loop
    
display_percentage:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop display_percentage
    
    ; Display % symbol
    mov dl, '%'
    mov ah, 02h
    int 21h
    
    ; Display fuel gauge
    mov dh, 9
    mov dl, 10
    call set_cursor
    
    mov ah, 09h
    mov bl, 0Eh  ; Yellow
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset fuel_gauge_full
    int 21h
    
    ; Check for low fuel
    mov ax, fuel_level
    cmp ax, 300  ; Low fuel threshold
    jg fuel_ok
    
    ; Display low fuel warning
    mov dh, 11
    mov dl, 10
    call set_cursor
    
    mov ah, 09h
    mov bl, WARNING_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset fuel_warning_msg
    int 21h
    
fuel_ok:
    ; Draw footer
    call draw_status_bar
    
    mov dx, offset press_key_msg
    call display_status
    
    ; Wait for key press before returning
    mov ah, 00h
    int 16h
    
    ret
fuel_monitoring_module endp
                              
                              
                              
                              
                              
                              
                              
                              
; Simulate landing request
simulate_landing_request proc
    ; Random chance of landing request
    mov ah, 00h
    int 1Ah      ; Get system time in CX:DX
    
    mov ax, dx
    and ax, 0003h ; Mask to get value 0-3
    
    cmp al, 0    ; 25% chance of landing request
    jne no_landing_request
    
    ; Add to landing queue
    mov al, queue_size
    cmp al, MAX_FLIGHTS
    jge queue_full
    
    inc queue_size
    
    ; Display landing request message
    call draw_status_bar
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset landing_request_msg
    int 21h
    
queue_full:
no_landing_request:
    ret
simulate_landing_request endp   






; Process landing requests
process_landing_requests proc
    ; Check if there are any landing requests
    cmp queue_size, 0
    je no_requests
    
    ; Check runway status
    cmp runway_status, 0
    jne runway_busy
    
    ; Grant landing clearance
    mov runway_status, 1
    dec queue_size
    
    ; Display landing cleared message
    call draw_status_bar
    
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset landing_cleared_msg
    int 21h
    
    ; Simulate runway being occupied for a short time
    mov cx, 0FFFFh
delay_loop:
    loop delay_loop
    
    ; Free runway
    mov runway_status, 0
    
    jmp no_requests
    
runway_busy:
    ; Display landing denied message
    call draw_status_bar
    
    mov ah, 09h
    mov bl, WARNING_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset landing_denied_msg
    int 21h
    
no_requests:
    ret
process_landing_requests endp
                              
                              
                              
                              
                              
                              
                              
input_flight_details proc 
    ; Increment flight counter
    inc flight_count
    
    ; Draw input form with border
    mov dh, 3  ; Start row
    mov dl, 10 ; Start column
    call set_cursor
    
    ; Set form title color
    mov ah, 09h  
    mov bl, HEADER_COLOR
    mov cx, 1
    int 10h
    
    ; Form title
    mov ah, 09h
    mov dx, offset form_title
    int 21h
    
    ; Flight number 
    mov dh, 5
    mov dl, 10
    call set_cursor
    
    ; Label in highlight color
    mov ah, 09h  
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset msg1
    int 21h
    
    ; Reset to input color for user input
    mov ah, 09h  
    mov bl, INPUT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 0Ah
    mov dx, offset flight_no
    int 21h

    ; Input destination 
    mov dh, 7
    mov dl, 10
    call set_cursor
    
    ; Label in highlight color
    mov ah, 09h  
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset msg2
    int 21h
    
    ; Reset to input color for user input
    mov ah, 09h  
    mov bl, INPUT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 0Ah
    mov dx, offset destination
    int 21h

    ; Starting place
    mov dh, 9
    mov dl, 10
    call set_cursor
    
    ; Label in highlight color
    mov ah, 09h  
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset msg4
    int 21h
    
    ; Reset to input color for user input
    mov ah, 09h  
    mov bl, INPUT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 0Ah
    mov dx, offset source
    int 21h

    ; Departure time
    mov dh, 11
    mov dl, 10
    call set_cursor
    
    ; Label in highlight color
    mov ah, 09h  
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset msg3
    int 21h
    
    ; Reset to input color for user input
    mov ah, 09h  
    mov bl, INPUT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 0Ah
    mov dx, offset dep_time
    int 21h
    
    ; Initial fuel level
    mov dh, 13
    mov dl, 10
    call set_cursor
    
    ; Label in highlight color
    mov ah, 09h  
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset msg5
    int 21h
    
    ; Reset to input color for user input
    mov ah, 09h  
    mov bl, INPUT_COLOR
    mov cx, 1
    int 10h
    
    ; Get fuel level as number
    call read_number
    mov fuel_level, ax

    ret
input_flight_details endp     





; Read a number from keyboard
read_number proc
    push bx
    push cx
    push dx
    
    mov bx, 0  ; Result
    mov cx, 5  ; Max digits
    
read_digit:
    mov ah, 01h
    int 21h
    
    cmp al, 13  ; Enter key
    je read_done
    
    cmp al, '0'
    jb invalid_digit
    cmp al, '9'
    ja invalid_digit
    
    sub al, '0'  ; Convert to binary
    
    ; Save the digit temporarily
    mov dl, al
    
    ; Multiply current result by 10
    mov ax, bx
    mov cx, 10
    mul cx
    mov bx, ax
    
    ; Add new digit
    mov dh, 0    ; Zero-extend DL to DX by clearing DH
    add bx, dx
    
    ; Continue reading (up to 5 digits)
    mov cx, 5
    loop read_digit
    jmp read_done
    
invalid_digit:
    ; Ignore invalid input
    jmp read_digit
    
read_done:
    mov ax, bx  ; Return result in AX
    
    pop dx
    pop cx
    pop bx
    ret
read_number endp

form_title db 'FLIGHT DETAILS ENTRY FORM$'
atc_title db 'AIR TRAFFIC CONTROL CENTER$'
fuel_title db 'FUEL MONITORING SYSTEM$'
runway_status_label db 'Runway Status: $'
runway_free_msg db 'FREE$'
runway_occupied_msg db 'OCCUPIED$'
landing_queue_label db 'Landing Queue: $'

calculate_travel_time proc
    ; Combine source and destination into route string
    mov si, offset source+2
    mov di, offset chennai_bangalore
    call combine_strings
    
    mov al, '-'
    stosb
    
    mov si, offset destination+2
    call combine_strings
    
    mov al, '$'
    stosb
    
    ; Check routes
    mov si, offset chennai_bangalore
    mov di, offset chennai_bangalore
    call compare_strings
    jc set_chennai_bangalore_time
    
    mov si, offset chennai_bangalore
    mov di, offset chennai_coimbatore
    call compare_strings
    jc set_chennai_coimbatore_time
    
    mov si, offset chennai_bangalore
    mov di, offset coimbatore_bangalore
    call compare_strings
    jc set_coimbatore_bangalore_time
    
    mov travel_time, 0
    ret
    
set_chennai_bangalore_time:
    mov travel_time, 5
    ret
    
set_chennai_coimbatore_time:
    mov travel_time, 7
    ret
    
set_coimbatore_bangalore_time:
    mov travel_time, 1
    ret
calculate_travel_time endp

calculate_arrival_time proc
    ; Parse departure time
    mov si, offset dep_time+2
    call parse_time
    
    ; Add travel time
    mov al, hours
    add al, byte ptr travel_time
    mov hours, al
    
    ; Handle 24-hour overflow
    cmp hours, 24
    jb no_hour_overflow
    sub hours, 24
no_hour_overflow:
    
    ; Format arrival time
    call format_time
    
    ; Update fuel level based on travel time
    mov ax, fuel_consumption
    mul travel_time
    
    ; Check if we have enough fuel
    cmp fuel_level, ax
    jb fuel_depleted
    
    ; Subtract fuel consumption
    sub fuel_level, ax
    jmp fuel_ok_arrival
    
fuel_depleted:
    ; Set fuel to zero if depleted
    mov fuel_level, 0
    
fuel_ok_arrival:
    ret
calculate_arrival_time endp

parse_time proc
    ; Parse HH:MM time string at SI
    mov al, [si]
    sub al, '0'
    mov bl, 10
    mul bl
    mov bl, [si+1]
    sub bl, '0'
    add al, bl
    mov hours, al
    
    add si, 3
    
    mov al, [si]
    sub al, '0'
    mul bl
    mov bl, [si+1]
    sub bl, '0'
    add al, bl
    mov minutes, al
    
    ret
parse_time endp

format_time proc
    ; Format HH:MM into temp_buffer
    mov al, hours
    mov ah, 0
    mov bl, 10
    div bl
    add al, '0'
    mov [temp_buffer], al
    add ah, '0'
    mov [temp_buffer+1], ah
    
    mov [temp_buffer+2], ':'
    
    mov al, minutes
    mov ah, 0
    div bl
    add al, '0'
    mov [temp_buffer+3], al
    add ah, '0'
    mov [temp_buffer+4], ah
    
    mov [temp_buffer+5], '$'
    
    ret
format_time endp

combine_strings proc
combine_loop:
    lodsb
    cmp al, '$'
    je combine_done
    stosb
    jmp combine_loop
combine_done:
    ret
combine_strings endp

copy_string proc
copy_loop:
    lodsb
    stosb
    cmp al, '$'
    jne copy_loop
    ret
copy_string endp

compare_strings proc
compare_loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne strings_not_equal
    cmp al, '$'
    je strings_equal
    inc si
    inc di
    jmp compare_loop
    
strings_not_equal:
    clc
    ret
    
strings_equal:
    stc
    ret
compare_strings endp






display_flight_details proc
    ; Clear screen and redraw UI
    call clear_screen
    call draw_fancy_header
    
    ; Draw a box for flight details
    mov dh, 3
    mov dl, 5
    call set_cursor
    
    ; Display title with special color
    mov ah, 09h
    mov bl, HEADER_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset output_msg
    int 21h
    
    call draw_fancy_box
    
    ; Display flight details with highlighting
    mov dh, 5
    mov dl, 10
    call set_cursor
    
    ; Highlight labels
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight_label
    int 21h
    
    ; Reset color for values
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset flight_no+2
    int 21h
    
    mov dh, 7
    mov dl, 10
    call set_cursor
    
    ; Highlight labels
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset source_label
    int 21h
    
    ; Reset color for values
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset source+2
    int 21h
    
    mov dh, 9
    mov dl, 10
    call set_cursor
    
    ; Highlight labels
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset destination_label
    int 21h
    
    ; Reset color for values
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset destination+2
    int 21h
    
    mov dh, 11
    mov dl, 10
    call set_cursor
    
    ; Highlight labels
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset time_label
    int 21h
    
    ; Reset color for values
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset dep_time+2
    int 21h
    
    mov dh, 13
    mov dl, 10
    call set_cursor
    
    ; Highlight arrival label in special color
    mov ah, 09h
    mov bl, 0Eh  ; Yellow text for arrival time
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset arrival_label
    int 21h
    
    mov ah, 09h
    mov dx, offset temp_buffer
    int 21h
    
    ; Display fuel level
    mov dh, 15
    mov dl, 10
    call set_cursor
    
    ; Highlight fuel label
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset fuel_label
    int 21h
    
    ; Convert fuel level to string
    ; FIXED: Properly load the fuel_level value into AX
    mov ax, [fuel_level]  ; Use brackets to get the value stored at fuel_level
    call number_to_string
    
    ; Reset color for fuel value
    mov ah, 09h
    mov bl, NORMAL_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset temp_buffer
    int 21h
    
    ; Display "liters" text
    mov ah, 09h
    mov dx, offset liters_text
    int 21h
    
    ; Check for low fuel warning
    cmp word ptr [fuel_level], 300  ; Use brackets and specify size
    jg no_fuel_warning
    
    ; Display low fuel warning
    mov dh, 17
    mov dl, 10
    call set_cursor
    
    mov ah, 09h
    mov bl, WARNING_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset fuel_warning_msg
    int 21h
    
no_fuel_warning:
    ; Draw bottom border
    mov dh, 19
    mov dl, 0
    call set_cursor
    call draw_horizontal_line
    ret
display_flight_details endp





liters_text db ' liters$'

; Convert number to string
number_to_string proc
    push bx
    push cx
    push dx
    
    mov bx, 10
    mov cx, 0
    
    ; Handle zero case
    test ax, ax
    jnz convert_digits
    
    mov byte ptr [temp_buffer], '0'
    mov byte ptr [temp_buffer+1], '$'
    jmp conversion_done
    
convert_digits:
    ; Convert each digit
    mov dx, 0
    div bx
    push dx  ; Remainder (digit)
    inc cx
    test ax, ax
    jnz convert_digits
    
    ; Pop digits in reverse order
    mov di, offset temp_buffer
    
pop_digits:
    pop dx
    add dl, '0'
    mov [di], dl
    inc di
    loop pop_digits
    
    ; Add terminator
    mov byte ptr [di], '$'
    
conversion_done:
    pop dx
    pop cx
    pop bx
    ret
number_to_string endp

ask_for_another_flight proc
    ; Draw status bar for prompt
    call draw_status_bar
    
    ; Ask with color
    mov ah, 09h
    mov bl, HIGHLIGHT_COLOR
    mov cx, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset another_flight_prompt
    int 21h
    
    mov ah, 01h
    int 21h
    
    cmp al, 'y'
    je start_new_flight
    cmp al, 'Y'
    je start_new_flight
    
    ret
    
start_new_flight:
    mov si, offset flight_no+2
    mov cx, 10
    call clear_buffer
    
    mov si, offset destination+2
    mov cx, 20
    call clear_buffer
    
    mov si, offset source+2
    mov cx, 20
    call clear_buffer
    
    mov si, offset dep_time+2
    mov cx, 10
    call clear_buffer
    
    ; Clear screen for next flight entry
    call clear_screen
    call draw_fancy_header
    
    jmp input_flight_details
ask_for_another_flight endp   




clear_buffer proc
    mov al, '$'
clear_loop:
    mov [si], al
    inc si
    loop clear_loop
    ret
clear_buffer endp

clear_screen proc
    mov ax, 0600h    ; Scroll entire screen
    mov bh, NORMAL_COLOR    ; Normal attribute
    mov cx, 0000h    ; Upper left corner (0,0)
    mov dx, 184Fh    ; Lower right corner (24,79)
    int 10h          ; Call BIOS
    
    ; Reset cursor to top-left
    mov ah, 02h
    mov bh, 0
    mov dx, 0000h
    int 10h
    
    ret
clear_screen endp         






draw_fancy_header proc
    ; Draw top border with double lines
    mov dh, 0        ; Row 0
    mov dl, 0        ; Column 0
    call set_cursor
    
    ; Set header color
    mov ah, 09h
    mov bl, HEADER_COLOR    ; Blue background, white text
    mov cx, SCREEN_WIDTH
    int 10h
    
    ; Draw top border with title
    mov ah, 02h      ; Set cursor position
    mov bh, 0        ; Page 0
    mov dh, 0        ; Row 0
    mov dl, 0        ; Column 0
    int 10h
    
    ; Draw top-left corner
    mov ah, 02h
    mov dl, TOP_LEFT_CORNER
    int 21h
    
    ; Draw top border
    mov ah, 09h
    mov dx, offset dline_buffer
    int 21h
    
    ; Center the title
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 26    ; Approximate center position
    int 10h
    
    mov ah, 09h
    mov dx, offset title_text
    int 21h
    
    ; Draw subtitle
    mov ah, 02h
    mov bh, 0
    mov dh, 1
    mov dl, 15    ; Approximate center position
    int 10h
    
    mov ah, 09h
    mov dx, offset subtitle_text
    int 21h
    
    ; Draw horizontal line at row 2
    mov dh, 2
    mov dl, 0
    call set_cursor
    call draw_double_line
    
    ret
draw_fancy_header endp

draw_horizontal_line proc
    ; Draw a horizontal line at current cursor position
    push dx
    
    mov ah, 09h
    mov dx, offset hline_buffer
    int 21h
    
    pop dx
    ret
draw_horizontal_line endp

draw_double_line proc
    ; Draw a double horizontal line at current cursor position
    push dx
    
    mov ah, 09h
    mov dx, offset dline_buffer
    int 21h
    
    pop dx
    ret
draw_double_line endp

draw_fancy_box proc
    ; Draw a fancy box around the current content
    ; Top border
    mov dh, 4
    mov dl, 5
    call set_cursor
    
    ; Draw top-left corner
    mov ah, 02h
    mov dl, TOP_LEFT_CORNER
    int 21h
    
    ; Draw top horizontal line
    mov cx, 70  ; Width of box
    
top_line:
    mov ah, 02h
    mov dl, DOUBLE_LINE_BORDER
    int 21h
    loop top_line
    
    ; Draw top-right corner
    mov ah, 02h
    mov dl, TOP_RIGHT_CORNER
    int 21h
    
    ; Draw vertical borders
    mov cx, 14  ; Height of box
    
vertical_borders:
    ; Left border
    mov ah, 02h
    mov bh, 0
    mov dl, 5
    inc dh
    int 10h
    
    mov ah, 02h
    mov dl, DOUBLE_VERTICAL_BORDER
    int 21h
    
    ; Right border
    mov ah, 02h
    mov bh, 0
    mov dl, 76
    int 10h
    
    mov ah, 02h
    mov dl, DOUBLE_VERTICAL_BORDER
    int 21h
    
    loop vertical_borders
    
    ; Bottom border
    mov ah, 02h
    mov bh, 0
    mov dh, 19
    mov dl, 5
    int 10h
    
    ; Draw bottom-left corner
    mov ah, 02h
    mov dl, BOTTOM_LEFT_CORNER
    int 21h
    
    ; Draw bottom horizontal line
    mov cx, 70  ; Width of box
    
bottom_line:
    mov ah, 02h
    mov dl, DOUBLE_LINE_BORDER
    int 21h
    loop bottom_line
    
    ; Draw bottom-right corner
    mov ah, 02h
    mov dl, BOTTOM_RIGHT_CORNER
    int 21h
    
    ret
draw_fancy_box endp

draw_status_bar proc
    ; Draw status bar at bottom of screen
    mov ah, 02h
    mov bh, 0
    mov dh, 24    ; Last row
    mov dl, 0
    int 10h
    
    ; Set status bar color
    mov ah, 09h
    mov bl, HEADER_COLOR    ; Blue background, white text
    mov cx, SCREEN_WIDTH
    int 10h
    
    mov ah, 02h
    mov bh, 0
    mov dh, 24
    mov dl, 2    ; Slight indent
    int 10h
    
    ret
draw_status_bar endp

display_status proc
    ; DX should contain offset of status message
    mov ah, 09h
    int 21h
    ret
display_status endp

set_cursor proc
    ; Set cursor position to DH (row), DL (column)
    mov ah, 02h
    mov bh, 0
    int 10h
    ret
set_cursor endp

end start
