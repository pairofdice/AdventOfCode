#![allow(unused_variables)]
use std::fs::{self, File};
//use std::path::Path;
//use std::io::{BufReader, prelude::*};

mod part2;

struct Passport {
    /*
    byr (Birth Year)
    iyr (Issue Year)
    eyr (Expiration Year)
    hgt (Height)
    hcl (Hair Color)
    ecl (Eye Color)
    pid (Passport ID)
    cid (Country ID)
    */
    byr: u32,
    iyr: u32,
    eyr: u32,
    hgt: u32,
    hcl: String,
    ecl: String,
    pid: u64,
    cid: u32,
}

fn main() {
    let input = fs::read_to_string("test.txt").unwrap(); // File reading one-liner

    //println!("{}", input);

    let mut parse: Vec<&str> = Vec::new();
    let mut pps: Vec<Passport> = Vec::new();

    for line in input.lines() {
        if line == "" { // we have one passport's worth of data
            let mut pp: Passport ;
            println!("{:?}", &parse);

            for e in parse.iter() {
                let v: Vec<&str> = e.splitn(2, ':').collect();
                match v[0] {
                    "byr" => pp.byr = v[1].parse().unwrap(), // oof, to build Passports in pieces do we need ... methods
                    "iyr" => pp.iyr = v[1].parse().unwrap() ,
                    "eyr" => pp.eyr = v[1].parse().unwrap(),
                    "hgt" => pp.hgt = v[1].parse().unwrap(),
                    "hcl" => pp.hcl = v[1].to_string(),
                    "ecl" => pp.ecl = v[1].to_string(),
                    "pid" => pp.pid = v[1].parse().unwrap(),
                    "cid" => pp.cid = v[1].parse().unwrap(),                  
                    _=> (),
                }
            }
            pps.push(pp);
            parse.clear();
            continue;
        }
        parse.extend(line.split(' '));
    }

    
    
    
    
    
    
    
    
    //println!("{}", part2::part2())
}



