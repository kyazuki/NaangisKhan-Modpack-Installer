use std::{
    error,
    fmt::{self, Display, Formatter},
};

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct Version {
    major: u32,
    minor: u32,
    patch: u32,
}

impl Version {
    pub const fn new(major: u32, minor: u32, patch: u32) -> Self {
        Self {
            major,
            minor,
            patch,
        }
    }

    pub fn from_str(v: &str) -> Result<Self, Error> {
        let mut version = vec![0, 0, 0];
        let v: Vec<&str> = v.split(".").collect();
        if v.len() != version.len() {
            return Err(Error::new(ErrorKind::NotSemanticsVersion));
        }
        for i in 0..version.len() {
            match v[i].parse::<u32>() {
                Ok(n) => {
                    version[i] = n;
                }
                Err(_) => {
                    return Err(Error::new(ErrorKind::NotNumberIncluded));
                }
            }
        }
        Ok(Version::new(version[0], version[1], version[2]))
    }

    pub fn is_old(&self, v: &Version) -> bool {
        self < v
    }
}

impl TryFrom<&str> for Version {
    type Error = Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        Version::from_str(value)
    }
}

impl Display for Version {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        write!(f, "{}.{}.{}", self.major, self.minor, self.patch)
    }
}

#[derive(Debug)]
pub struct Error {
    kind: ErrorKind,
}

impl Error {
    pub fn new(kind: ErrorKind) -> Self {
        Self { kind }
    }
}

impl error::Error for Error {}

impl Display for Error {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        match self.kind {
            ErrorKind::NotSemanticsVersion => write!(f, "The version number needs under 3 digits."),
            ErrorKind::NotNumberIncluded => write!(f, "Not number is included."),
        }
    }
}

#[derive(Debug)]
pub enum ErrorKind {
    NotSemanticsVersion,
    NotNumberIncluded,
}
