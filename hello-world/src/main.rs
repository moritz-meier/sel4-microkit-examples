#![no_std]
#![no_main]

use core::{convert::Infallible, panic::PanicInfo};

use sel4_microkit::{protection_domain, Handler};

#[protection_domain]
fn init() -> impl Handler {
    HandlerImpl
}

struct HandlerImpl;

impl Handler for HandlerImpl {
    type Error = Infallible;
}
