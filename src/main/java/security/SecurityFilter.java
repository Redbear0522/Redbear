package security;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SecurityFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 필터 초기화
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // 보안 헤더 설정
        httpResponse.setHeader("X-Frame-Options", "SAMEORIGIN"); // clickjacking 방지
        httpResponse.setHeader("X-Content-Type-Options", "nosniff"); // MIME 스니핑 방지
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block"); // XSS 방어
        httpResponse.setHeader("Referrer-Policy", "same-origin"); // 리퍼러 정책
        httpResponse.setHeader("Content-Security-Policy", 
            "default-src 'self' https:; " +
            "script-src 'self' 'unsafe-inline' https:; " +
            "style-src 'self' 'unsafe-inline' https:; " +
            "img-src 'self' data: https:; " +
            "font-src 'self' https:;");
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 필터 종료
    }
}
