erlmonitor
=====

An Erlang Web Monitor

Build & Run
--------------

    $ make
    $ ./start.sh
    
Why a new monitor
---------------------
Compare to entop:

    1.entop is very useful but have to login the console
    2.entop is can only monitor a node
    3.entop is not so beautiful
    4.entop is not convenient
    5.entop can only monitor top xxx process not all
    6.entop is not so powerful, it just have such function. I need more 
    
    ErlMonitor will be powerful entop, but not just entop.
    
Compare to other web monitor::
    
    There are a few web monitor, but:
    1.None of them can replace entop thing
    2.None of them can monitor other node, no matter nodes
    3.None of them is for real practice


Tasks
-------

- entop like function

    - [x] start the project
    - [x] just monitor memory, message_queue of pid list
    - [x] a simple tool (implement the basic) like entop
    - [x] sort
    - [ ] socket mode:
        - controlled by server
        - just caculate once no matter how many clients
    - [ ] monitor muli nodes

- Interface 

    - [x] ugly
    - [ ] basic
    - [ ] normal
    - [ ] beautiful

- Code Decompilation

    - [ ] basic function
    - [ ] multi nodes
    - [ ] beautiful display

- System Level Monitor
    
    - [ ] Memory, CPU, Task
    - [ ] Application is work Fine



Thanks
------------

- entop
- recon


    
    
