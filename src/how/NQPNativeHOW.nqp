knowhow NQPNativeHOW {
    has $!name;
    has $!nativesize;
    has $!unsigned;
    has $!composed;

    my $archetypes := Archetypes.new( :nominal(1) );
    method archetypes($obj?) { $archetypes }

    method new(:$name) {
        my $obj  := nqp::create(self);
        my $what := $obj.WHAT;

        nqp::bindattr($obj, $what, '$!name',     $name);
        nqp::bindattr($obj, $what, '$!unsigned', 0    );

        $obj
    }

    # Create a new meta-class instance, and then a new type object
    # to go with it, and return that
    method new_type(:$name = '<anon>', :$repr!) {
        my $metaclass := self.new(:name($name));
        my $type := nqp::newtype($metaclass, $repr);
        nqp::settypehll($type, 'nqp');
        nqp::setdebugtypename(nqp::setwho($type, nqp::hash), $name)
    }

    method add_method($obj, $name, $code_obj) {
        nqp::die("Native types may not have methods (must be boxed to call method)");
    }

    method add_multi_method($obj, $name, $code_obj) {
        nqp::die("Native types may not have methods (must be boxed to call method)");
    }

    method add_attribute($obj, $meta_attr) {
        nqp::die("Native types may not have attributes");
    }

    method compose($obj) {
        if !$!composed && ($!nativesize || $!unsigned) {
            nqp::composetype($obj, nqp::hash(
              'integer',
              nqp::hash('unsigned', $!unsigned, 'bits', $!nativesize),
              'float',
              nqp::hash('bits', $!nativesize)
            ));
            $!composed := 1;
        }
    }

    method name($obj) { $!name }
    method nativesize($obj) { $!nativesize }
    method unsigned($obj) { $!unsigned }

    method set_nativesize($obj, $nativesize) {
        $!nativesize := $nativesize;
    }
    method set_unsigned($obj, $unsigned) {
        $!unsigned := $unsigned ?? 1 !! 0
    }

    method shortname($obj) {
        my @parts := nqp::split('::', self.name($obj) // '');
        @parts ?? nqp::atpos(@parts, nqp::elems(@parts) - 1) !! '<anon>'
    }
}
