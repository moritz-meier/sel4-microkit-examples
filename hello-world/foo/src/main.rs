#![no_std]
#![no_main]

use core::{arch::asm, convert::Infallible, panic::PanicInfo};

use sel4_microkit::{memory_region_symbol, protection_domain, Handler};

struct HandlerImpl;

impl Handler for HandlerImpl {
    type Error = Infallible;
}

#[protection_domain]
fn init() -> impl Handler {
    sel4_microkit::debug_println!("Hello World!!!!!");

    loop {
        unsafe { asm!("nop") };
        sel4_microkit::debug_println!("foo");
    }

    return HandlerImpl;
}
