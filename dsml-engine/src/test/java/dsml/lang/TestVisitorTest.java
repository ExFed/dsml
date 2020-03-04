package dsml.lang;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CodePointCharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class TestVisitorTest {

    @Test
    void visitSpecification() {
        String expect = "" +
                "biz --[ foobar ]-> baz\n" +
                "quz --[ xyzzy ]-> qaz";
        String input = "" +
                "foobar biz: baz\n" +
                "xyzzy quz: qaz\n";
        CodePointCharStream cs = CharStreams.fromString(input);
        DSMLLexer dsmlLexer = new DSMLLexer(cs);
        CommonTokenStream tokens = new CommonTokenStream(dsmlLexer);
        DSMLParser dsmlParser = new DSMLParser(tokens);

        TestVisitor visitor = new TestVisitor();
        String actual = visitor.visit(dsmlParser.file());
        assertEquals(expect, actual);
    }
}
