import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-16">
        <div className="text-center mb-16">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Welcome to EduFlow
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Modern SaaS platform for school management
          </p>
          <div className="flex gap-4 justify-center">
            <Button size="lg">Get Started</Button>
            <Button variant="outline" size="lg">Learn More</Button>
          </div>
        </div>

        <div className="grid md:grid-cols-3 gap-8 mb-16">
          <Card>
            <CardHeader>
              <CardTitle>Multi-Tenant</CardTitle>
              <CardDescription>
                Secure isolation for multiple educational institutions
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p>Each school operates in its own secure environment with complete data isolation.</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Comprehensive</CardTitle>
              <CardDescription>
                All-in-one solution for school management
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p>Student management, attendance, grades, finances, and more in one platform.</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>AI-Powered</CardTitle>
              <CardDescription>
                Intelligent features for better education
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p>Automated report generation, performance prediction, and smart insights.</p>
            </CardContent>
          </Card>
        </div>

        <div className="text-center">
          <h2 className="text-3xl font-bold text-gray-900 mb-8">
            Supported Institution Types
          </h2>
          <div className="grid md:grid-cols-4 gap-6">
            <div className="p-6 bg-white rounded-lg shadow-md">
              <h3 className="text-lg font-semibold mb-2">Primary Schools</h3>
              <p className="text-gray-600">Complete management for elementary education</p>
            </div>
            <div className="p-6 bg-white rounded-lg shadow-md">
              <h3 className="text-lg font-semibold mb-2">Secondary Schools</h3>
              <p className="text-gray-600">Advanced features for high school management</p>
            </div>
            <div className="p-6 bg-white rounded-lg shadow-md">
              <h3 className="text-lg font-semibold mb-2">Universities</h3>
              <p className="text-gray-600">Scalable solution for higher education</p>
            </div>
            <div className="p-6 bg-white rounded-lg shadow-md">
              <h3 className="text-lg font-semibold mb-2">Training Centers</h3>
              <p className="text-gray-600">Flexible platform for vocational training</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}