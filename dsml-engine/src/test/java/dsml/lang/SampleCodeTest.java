package dsml.lang;

import dsml.lang.visitors.DSMLFileVisitor;
import dsml.lang.visitors.StringTriple;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class SampleCodeTest {

    private DSMLParser makeParser(String filename) throws IOException {
        DSMLParser parser;
        try (InputStream is = this.getClass().getResourceAsStream(filename)) {
            final CharStream cs = CharStreams.fromStream(is);
            final DSMLLexer lexer = new DSMLLexer(cs);
            final CommonTokenStream tokens = new CommonTokenStream(lexer);
            parser = new DSMLParser(tokens);
        }
        return parser;
    }

    @Test
    void testFQName() throws IOException {
        final List<StringTriple> expect = Arrays.asList(
                new StringTriple("awesome", "sauce", "property"),
                new StringTriple("some", "cool", "spec"),
                new StringTriple("some", "cool", "spec")
        );

        final DSMLParser parser = makeParser("FQName.dsml");

        final List<StringTriple> actual = new DSMLFileVisitor().visit(parser.file());
        assertEquals(expect, actual);
    }

    @Test
    void testTriple() throws IOException {
        final List<Object> expect = Arrays.asList(
                new StringTriple("some", "cool", "spec")
        );

        final DSMLParser parser = makeParser("Triple.dsml");

        final List<StringTriple> actual = new DSMLFileVisitor().visit(parser.file());
        assertEquals(expect, actual);
    }
}
