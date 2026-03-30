/**
 * API Client
 * Centralized HTTP request handler with error handling
 */

export class APIClient {
  constructor(baseURL = '') {
    this.baseURL = baseURL;
    this.defaultHeaders = {
      'Content-Type': 'application/json',
    };
    this.timeout = 10000; // 10 seconds
  }

  setToken(token) {
    this.defaultHeaders['Authorization'] = `Bearer ${token}`;
  }

  clearToken() {
    delete this.defaultHeaders['Authorization'];
  }

  async request(method, endpoint, options = {}) {
    const url = this.baseURL + endpoint;
    
    const config = {
      method,
      headers: { ...this.defaultHeaders, ...options.headers },
      timeout: options.timeout || this.timeout,
    };

    if (options.body) {
      config.body = typeof options.body === 'string' 
        ? options.body 
        : JSON.stringify(options.body);
    }

    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), config.timeout);

      const response = await fetch(url, {
        ...config,
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        throw new APIError(response.status, response.statusText);
      }

      const data = await response.json();
      return { success: true, data };
    } catch (error) {
      if (error instanceof APIError) {
        return { success: false, error: error.message };
      }
      
      if (error.name === 'AbortError') {
        return { success: false, error: 'Request timeout' };
      }

      return { success: false, error: error.message };
    }
  }

  get(endpoint, options = {}) {
    return this.request('GET', endpoint, options);
  }

  post(endpoint, body, options = {}) {
    return this.request('POST', endpoint, { ...options, body });
  }

  put(endpoint, body, options = {}) {
    return this.request('PUT', endpoint, { ...options, body });
  }

  patch(endpoint, body, options = {}) {
    return this.request('PATCH', endpoint, { ...options, body });
  }

  delete(endpoint, options = {}) {
    return this.request('DELETE', endpoint, options);
  }

  async uploadFile(endpoint, file, additionalData = {}) {
    const formData = new FormData();
    formData.append('file', file);

    Object.entries(additionalData).forEach(([key, value]) => {
      formData.append(key, value);
    });

    const url = this.baseURL + endpoint;
    const headers = { ...this.defaultHeaders };
    delete headers['Content-Type']; // Let browser set it

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers,
        body: formData,
      });

      if (!response.ok) {
        throw new APIError(response.status, response.statusText);
      }

      const data = await response.json();
      return { success: true, data };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }
}

export class APIError extends Error {
  constructor(status, statusText) {
    super(`HTTP Error ${status}: ${statusText}`);
    this.status = status;
    this.statusText = statusText;
  }
}
